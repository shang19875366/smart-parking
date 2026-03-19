<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 顶部导航 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
      <div class="container mx-auto px-4 py-4 flex items-center">
        <button @click="$router.back()" class="mr-4">
          <span class="text-xl">←</span>
        </button>
        <h1 class="text-xl font-bold text-gray-800 dark:text-white">{{ parking.name }}</h1>
      </div>
    </header>
    <!-- 停车场信息 -->
    <section class="bg-white dark:bg-gray-800 p-6">
      <div class="flex flex-col md:flex-row gap-6">
        <!-- 左侧信息 -->
        <div class="md:w-2/3">
          <div class="mb-6">
            <h2 class="text-2xl font-bold mb-2 text-gray-800 dark:text-white">{{ parking.name }}</h2>
            <p class="text-gray-600 dark:text-gray-400 mb-4">{{ parking.address }}</p>
            <div class="flex items-center mb-4">
              <span class="text-primary mr-2">💰</span>
              <span class="text-gray-800 dark:text-white">{{ parking.fee }}元/小时</span>
            </div>
            <div class="flex items-center mb-4">
              <span class="text-primary mr-2">📍</span>
              <span class="text-gray-800 dark:text-white">经度: {{ parking.longitude }}, 纬度: {{ parking.latitude }}</span>
            </div>
            <div class="flex items-center">
              <span class="text-primary mr-2">📞</span>
              <span class="text-gray-800 dark:text-white">{{ parking.phone || '暂无联系电话' }}</span>
            </div>
          </div>
          <div class="mb-6">
            <button class="w-full px-4 py-3 bg-primary text-white rounded-lg hover:bg-blue-600">
              导航到这里
            </button>
          </div>
          <!-- 评论区域 -->
          <div>
            <h3 class="text-xl font-semibold mb-4 text-gray-800 dark:text-white">用户评论</h3>
            <div class="space-y-4">
              <div v-for="comment in comments" :key="comment.id" class="p-4 border border-gray-200 dark:border-gray-700 rounded-lg">
                <div class="flex justify-between items-start mb-2">
                  <h4 class="font-medium text-gray-800 dark:text-white">{{ comment.user_name }}</h4>
                  <span class="text-sm text-gray-500 dark:text-gray-400">{{ comment.created_at }}</span>
                </div>
                <p class="text-gray-600 dark:text-gray-300">{{ comment.content }}</p>
              </div>
            </div>
            <!-- 评论输入框 -->
            <div class="mt-6">
              <textarea 
                placeholder="写下你的评论..." 
                class="w-full p-4 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200 resize-none"
                rows="3"
              ></textarea>
              <div class="mt-3 flex justify-end">
                <button class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600">
                  提交评论
                </button>
              </div>
            </div>
          </div>
        </div>
        <!-- 右侧地图 -->
        <div class="md:w-1/3">
          <div class="bg-gray-200 dark:bg-gray-700 rounded-lg h-64 flex items-center justify-center">
            <span class="text-gray-500 dark:text-gray-400">地图显示区域</span>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script>
import { supabase } from '../../services/supabase'

export default {
  name: 'CDetail',
  data() {
    return {
      parking: {
        id: '',
        name: '',
        address: '',
        latitude: '',
        longitude: '',
        fee: '',
        phone: ''
      },
      comments: []
    }
  },
  mounted() {
    const id = this.$route.params.id
    this.fetchParkingDetail(id)
    this.fetchComments(id)
  },
  methods: {
    async fetchParkingDetail(id) {
      try {
        const { data, error } = await supabase
          .from('parking_lots')
          .select('*')
          .eq('id', id)
          .single()
        
        if (error) {
          console.error('获取停车场详情失败:', error)
          return
        }
        
        this.parking = data
      } catch (error) {
        console.error('获取停车场详情异常:', error)
      }
    },
    async fetchComments(id) {
      try {
        const { data, error } = await supabase
          .from('comments')
          .select('*')
          .eq('parking_id', id)
        
        if (error) {
          console.error('获取评论数据失败:', error)
          this.comments = []
          return
        }
        
        this.comments = data
      } catch (error) {
        console.error('获取评论数据异常:', error)
        this.comments = []
      }
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>