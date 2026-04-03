<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 顶部导航 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
      <div class="container mx-auto px-4 py-4 flex items-center">
        <el-button @click="router.back()" icon="ArrowLeft" circle></el-button>
        <h1 class="text-xl font-bold text-gray-800 dark:text-white">{{ parking.name }}</h1>
      </div>
    </header>
    <!-- 停车场信息 -->
    <section class="bg-white dark:bg-gray-800 p-6">
      <div class="flex flex-col md:flex-row gap-6">
        <!-- 左侧信息 -->
        <div class="md:w-2/3">
          <el-card shadow="hover" class="mb-6">
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
          </el-card>
          <div class="mb-6">
            <el-button type="primary" size="large" class="w-full" @click="navigateToParking">
              导航到这里
            </el-button>
          </div>
          <!-- 评论区域 -->
          <div>
            <h3 class="text-xl font-semibold mb-4 text-gray-800 dark:text-white">用户评论</h3>
            <div class="space-y-4">
              <el-card v-for="comment in comments" :key="comment.id" shadow="hover">
                <div class="flex justify-between items-start mb-2">
                  <h4 class="font-medium text-gray-800 dark:text-white">{{ comment.user_name }}</h4>
                  <span class="text-sm text-gray-500 dark:text-gray-400">{{ comment.created_at }}</span>
                </div>
                <p class="text-gray-600 dark:text-gray-300">{{ comment.content }}</p>
              </el-card>
              <div v-if="comments.length === 0" class="text-center py-4 text-gray-500">
                暂无评论
              </div>
            </div>
            <!-- 评论输入框 -->
            <div class="mt-6">
              <el-input
                v-model="commentContent"
                type="textarea"
                placeholder="写下你的评论..."
                :rows="3"
              />
              <div class="mt-3 flex justify-end">
                <el-button type="primary" @click="submitComment">
                  提交评论
                </el-button>
              </div>
            </div>
          </div>
        </div>
        <!-- 右侧地图 -->
        <div class="md:w-1/3">
          <el-card shadow="hover" class="h-64 flex items-center justify-center">
            <span class="text-gray-500 dark:text-gray-400">地图显示区域</span>
          </el-card>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { supabase } from '../../services/supabase'

const router = useRouter()
const route = useRoute()

const parking = ref({
  id: '',
  name: '',
  address: '',
  latitude: '',
  longitude: '',
  fee: '',
  phone: ''
})
const comments = ref([])
const commentContent = ref('')

const fetchParkingDetail = async (id) => {
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
    
    parking.value = data
  } catch (error) {
    console.error('获取停车场详情异常:', error)
  }
}

const fetchComments = async (id) => {
  try {
    const { data, error } = await supabase
      .from('comments')
      .select('*')
      .eq('parking_id', id)
    
    if (error) {
      console.error('获取评论数据失败:', error)
      comments.value = []
      return
    }
    
    comments.value = data
  } catch (error) {
    console.error('获取评论数据异常:', error)
    comments.value = []
  }
}

const navigateToParking = () => {
  // 导航功能实现
  console.log('导航到:', parking.value.name)
  // 这里可以添加导航逻辑
}

const submitComment = async () => {
  if (!commentContent.value.trim()) {
    return
  }
  
  try {
    const { data, error } = await supabase
      .from('comments')
      .insert({
        parking_id: parking.value.id,
        user_name: '测试用户', // 实际项目中应该从认证系统获取
        content: commentContent.value,
        status: 'active'
      })
      .select()
    
    if (error) {
      console.error('提交评论失败:', error)
      return
    }
    
    // 重新获取评论
    fetchComments(parking.value.id)
    // 清空输入框
    commentContent.value = ''
  } catch (error) {
    console.error('提交评论异常:', error)
  }
}

onMounted(() => {
  const id = route.params.id
  fetchParkingDetail(id)
  fetchComments(id)
})
</script>

<style scoped>
/* 自定义样式 */
</style>