<template>
    <v-card>
        <v-card-title style="background-color: #CCFFCC">
            <span class="text-h5">Edit Todo</span>
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text>
        <v-container>
            <v-row>
                <v-col cols="12" sm="6" md="4">
                    <v-text-field
                    label="タスク*"
                    required
                    v-model="data.title"
                    ></v-text-field>
                </v-col>
                <v-col cols="12">
                    <datetime
                    v-model="data.date"
                    type="datetime"
                    input_id="startDate"
                    hidden-name="hidden name"
                    format="yyyy-MM-dd HH:mm"
                    placeholder="2021-06-04 11:11"
                    >
                        <label slot="before" for="startDate">開始日:</label>
                    </datetime>
                    <v-divider
                    style="background-color: black; width: 180px"
                    ></v-divider>
                </v-col>
                <v-col cols="12">
                    <v-textarea label="説明" v-model="data.description"></v-textarea>
                </v-col>
            </v-row>
        </v-container>
        <small>*indicates required field</small>
        </v-card-text>
        <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="cancel"> Close </v-btn>
            <v-btn color="blue darken-1" text @click="submit"> Save </v-btn>
        </v-card-actions>
    </v-card>
</template>

<script>
import { Datetime } from 'vue-datetime'
import 'vue-datetime/dist/vue-datetime.css'

export default {
    components: {
        datetime: Datetime
    },
    props: {
        title: String,
        description: String,
        datetime: Date,
    },
    data() {
        return {
            data: {
                title: this.title,
                description: this.description,
                date: this.datetime
            },
        }
    },
    methods: {
        cancel() {
            this.$emit('cancelDialog')
            this.data = {}
        },
        submit() {
            this.$emit('clickSubmit', this.data)
            this.data = {}
        }
    }
}
</script>