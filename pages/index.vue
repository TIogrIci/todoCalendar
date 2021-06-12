<template>
  <div class="container"
  >
    <v-container
      class="ma-0 py-8 px-6"
      style="max-width:2000px"
    >
      <div id="form-control">
        <v-form class="mb-0">
          <v-text-field
            v-model="data.title"
            label="タスクを追加する"
            :append-icon="'mdi-pencil'"
            :append-outer-icon="'mdi-send'"
            filled
            rounded
            clear-icon="mdi-close-circle"
            clearable
            type="text"
            @click:append="editMessage"
            @click:append-outer="postMessage"
            @click:clear="clearMessage"
          ></v-text-field>
        </v-form>
          
        <v-dialog v-model="dialog">
          <task-edit-dialog
            @clickSubmit="post"
            @cancelDialog="cancel"
            :title="data.title"
            :description="data.description"
            :datetime="data.datetime"
          ></task-edit-dialog>
        </v-dialog>
      </div>

      <v-row>
        <v-col
          v-for="card in cards"
          :key="card"
          cols="12"
        >
          <v-card outlined>
            <v-subheader>{{ card }}</v-subheader>
              <v-list two-line>
                <v-list-item
                  v-for="(list,index) in data_list"
                  :key="index"
                  id="list-item"
                  style="height: 10px"
                >
                  <v-list-item-title>{{ list.title }}</v-list-item-title>
                  <v-list-item-subtitle>{{ list.description }}</v-list-item-subtitle>
                  <v-list-item-title>{{ formatTime }}</v-list-item-title>
                  <v-list-item-icon>
                    <v-icon
                      class="mt-1"
                      v-if="!timerOn"
                      @click="startTimer"
                    > 
                      mdi-play 
                    </v-icon>
                    <v-icon
                      class="mt-1"
                      v-if="timerOn"
                      @click="stopTimer"
                    >
                      mdi-stop
                    </v-icon>
                  </v-list-item-icon>

                  <v-list-item-icon>
                    <v-menu offset-y>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon class="pt-1" v-bind="attrs" v-on="on"> mdi-dots-vertical </v-icon>
                      </template>
                      <v-list>
                        <v-list-item v-for="(menuItem, index) in menuItems" :key="index">
                          <v-list-item-title>{{ menuItem }}</v-list-item-title>
                        </v-list-item>
                      </v-list>
                    </v-menu>
                  </v-list-item-icon>
                  <v-divider class="mt-2"></v-divider>
                </v-list-item>
              </v-list>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'
import  taskEditDialog from '~/components/taskEditDialog.vue'

export default {
  components: {
    datetime: Datetime,
    taskEditDialog
  },
  layout (context) {
    return 'sidebar'
  },
  data: () => ({
    cards: ['Today', 'Yesterday'],
    data: {
      title: "",
      description: "",
      datetime: null
    },
    data_list: [],
    dialog: false,
    datetime: null,
    menuItems: ["編集", "削除"],
    sec: 0,
    timerOn: false,
    timerObj: null,
  }),
  methods: {
    postMessage() {
      const url = '/api/todos';
      const todo = {
        title: this.data.title,
        description: this.data.description,
        date: this.data.datetime,
      };
      console.log(todo);
      this.$axios.post(url, { todo })
        .then(
          res => {
            console.log(res.data.data)
            this.data_list.push(res.data.data)
          }
        )
        .catch(error => console.log(error));
        this.data.title = ""
        this.data.description = ""
    },
    post(params) {
      this.dialog = false
      const todo = {
        title: params.title,
        description: params.description,
        date: params.datetime,
      };
      this.$axios.post('/api/todos', { todo })
        .then(
          res => {
            console.log(res.data.data)
            this.data_list.push(res.data.data)
          }
        )
        .catch(error => console.log(error));
        this.data.title = ""
        this.data.description = ""
    },
    cancel() {
      this.dialog = false
    },
    clearMessage() {
      this.data.title = ""
    },
    editMessage() {
      this.dialog = true
    },
    startTimer() {
      this.timerObj = setInterval(() => { this.sec++ }, 1000)
      this.timerOn = true
    },
    stopTimer() {
      clearInterval(this.timerObj)
      this.timerOn = false
    },
  },
  computed: {
    formatTime() {
      const rawSec = this.sec
      let sec = String(rawSec % 3600)
      if (sec.length == 1) { sec = "0" + sec }
      let min = String(Math.floor(rawSec / 60) % 60)
      if (min.length == 1) { min = "0" + min }
      let hour = String(Math.floor(rawSec / 3600))
      if (hour.length == 1) { hour = "0" + hour }
      let time = hour + ":" + min + ":" + sec
      return time
    }
  }
}
</script>

<style scoped>
  .container {
    max-width: 100%;
    width: auto;
    margin-left: 0%;
    margin-right: 0%;
    display: block;
  }

  #list-item:hover {
    background-color: #EEEEEE;
  }

</style>