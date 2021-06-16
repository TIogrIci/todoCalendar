<template>
    <v-card>
        <v-card-title style="background-color: #CCFFCC">
            <span class="text-h5"></span>
        </v-card-title>
        <v-divider></v-divider>
        <v-card-text>
        <v-container>
            <v-row>
                <v-col>
                    <h3 style="color: red">削除しますがよろしいですか？</h3>
                </v-col>
            </v-row>
        </v-container>
        </v-card-text>
        <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue darken-1" text @click="no"> いいえ </v-btn>
            <v-btn color="blue darken-1" text @click="yes"> はい </v-btn>
        </v-card-actions>
    </v-card>
</template>

<script>


export default {
    methods: {
        no() {
            this.$emit('notDeleteTodo')
        },
        yes() {
            this.$emit('deleteTodo')
        }
    }
}
</script>