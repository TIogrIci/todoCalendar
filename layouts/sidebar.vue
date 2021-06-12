<template>
    <div>
        <v-app>
            <v-navigation-drawer
            v-model="drawer"
            app
            width="220"
            color="#336600"
            
        >
            <v-sheet
                class="pa-4"
                color="#336600"
                style="color: white"
            >
                <v-avatar
                    class="mb-4"
                    size="64"
                    color="indigo darken-1"
                >
                    <v-icon dark>
                        mdi-account-circle
                    </v-icon>
                </v-avatar>

                <div>test@localhost.com</div>
            </v-sheet>

            <v-divider></v-divider>

            <v-list-item
                v-for="item in items"
                :key="item.title"
                link
            >
                <v-list-item-icon>
                    <v-icon style="color: white">{{ item.icon }}</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                    <v-list-item-title style="color: white">{{ item.title }}</v-list-item-title>
                </v-list-item-content>
            </v-list-item>
        </v-navigation-drawer>
        <v-main style="background-color: #FFFAFA">
            <Nuxt />
        </v-main>
        </v-app>
        
    </div>
</template>


<script>
export default {
    data () {
        return {
            items: [
                { title: 'Dashboard', icon: 'mdi-view-dashboard' },
                { title: 'Photos', icon: 'mdi-image' },
                { title: 'About', icon: 'mdi-help-box' },
            ],
            drawer: null
        }
    }
}
</script>