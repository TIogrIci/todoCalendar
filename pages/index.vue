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
                  v-for="(list,list_index) in data_list"
                  :key="list_index"
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
                    <v-menu offset-y close-on-content-click>
                      <template v-slot:activator="{ on, attrs }">
                        <v-icon class="pt-1" v-bind="attrs" v-on="on"> mdi-dots-vertical </v-icon>
                      </template>
                      <v-list>
                        <v-list-item v-for="(menuItem, index) in menuItems" :key="index" @click.stop="selectMenuItem(menuItem)">
                          <v-list-item-title>{{ menuItem }}</v-list-item-title>
                        </v-list-item>
                      </v-list>
                    </v-menu>
                    <v-dialog v-model="editItemDialog" :retain-focus="false">
                      <task-edit-dialog
                        @clickSubmit="update"
                        @cancelDialog="cancel"
                        :title="list.title"
                        :description="list.description"
                        :datetime="list.datetime"
                        :editId="list_index"
                      ></task-edit-dialog>
                    </v-dialog>
                    <v-dialog v-model="deleteConfirmDialog" width="500" :retain-focus="false">
                      <delete-confirm-dialog
                        @notDeleteTodo="deleteConfirmDialog=false"
                        @deleteTodo="deleteTodo(list_index)"
                      ></delete-confirm-dialog>
                    </v-dialog>
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
import  deleteConfirmDialog from '~/components/deleteConfirmDialog.vue'

export default {
  components: {
    datetime: Datetime,
    taskEditDialog,
    deleteConfirmDialog
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
    editItemDialog: false,
    deleteConfirmDialog: false,
    editId: 0,
  }),
  methods: {
    postMessage() {
      const url = '/api/todos';
      const todo = {
        title: this.data.title,
        description: this.data.description,
        date: this.data.datetime,
      };
      //console.log(todo);
      this.$axios.post(url, { todo })
        .then(
          res => {
            //console.log(res.data.data)
            this.data_list.push(res.data.data)
            console.log("post data id:" + res.data.data.id)
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
        date: params.date,
      };
      this.$axios.post('/api/todos', { todo })
        .then(
          res => {
            this.data_list.push(res.data.data)
            console.log("post data id:" + res.data.data.id)
          }
        )
        .catch(error => console.log(error));
        this.data.title = ""
        this.data.description = ""
    },
    update(params) {
      this.editItemDialog = false
      const todo = {
        title: params.title,
        description: params.description,
        date: params.date,
      };
      const id = this.data_list[this.editId].id
      this.$axios.put('/api/todos/' + id, { todo })
        .then(
          res => {
            this.$set(this.data_list, this.editId, res.data.data)
            //this.data_list[this.editId] = res.data.data
            console.log(this.data_list);
          }
        )
        .catch(error => console.log(error));
        this.data.title = ""
        this.data.description = ""
    },
    cancel() {
      this.dialog = false
      this.editItemDialog = false
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
    selectMenuItem(value) {
      if(value == "編集") {
        this.editItemDialog = true
      } else if(value == "削除") {
        this.deleteConfirmDialog = true
      } else {
        console.log(value);
      }
    },
    deleteTodo(index) {
      console.log(this.deleteId);
      const id = this.data_list[index].id
      this.$axios.delete('/api/todos/' + id)
        .then(
          res => {
            const delete_id = res.data.data.id
            console.log(delete_id);
            //this.data_list.splice(delete_id, delete_id)
            this.data_list.splice(index, 1)
            console.log(this.data_list);
          }
        )
        .catch(error => console.log(error));
      this.deleteConfirmDialog = false
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