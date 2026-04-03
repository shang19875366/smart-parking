<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">用户评论管理</h2>
    </div>
    <!-- 搜索和筛选 -->
    <div class="flex flex-col md:flex-row gap-4 mb-6">
      <div class="flex-1">
        <el-input 
          v-model="searchQuery" 
          placeholder="搜索评论..." 
          prefix-icon="el-icon-search"
        />
      </div>
      <div class="flex gap-4">
        <el-select v-model="parkingFilter" placeholder="停车场">
          <el-option label="全部停车场" value="" />
          <el-option label="中央商场停车场" value="1" />
          <el-option label="国贸中心停车场" value="2" />
          <el-option label="三里屯SOHO停车场" value="3" />
        </el-select>
        <el-button type="success">筛选</el-button>
      </div>
    </div>
    <!-- 评论列表 -->
    <div class="space-y-4">
      <el-card v-for="comment in comments" :key="comment.id" shadow="hover">
        <div class="flex justify-between items-start mb-2">
          <div>
            <h4 class="font-medium text-gray-800 dark:text-white">{{ comment.user_name }}</h4>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ comment.created_at }}</p>
          </div>
          <div class="flex gap-2">
            <el-button type="danger" size="small" @click="deleteComment(comment.id)">删除</el-button>
          </div>
        </div>
        <p class="text-gray-600 dark:text-gray-300 mb-2">{{ comment.content }}</p>
        <div class="text-sm text-gray-500 dark:text-gray-400">
          停车场：{{ comment.parking_name || '未知' }}
        </div>
      </el-card>
    </div>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ comments.length }} 条记录</p>
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="comments.length"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../services/supabase'

const comments = ref([])
const searchQuery = ref('')
const parkingFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(10)

const fetchComments = async () => {
  try {
    const { data, error } = await supabase
      .from('comments')
      .select('*')
    
    if (error) {
      console.error('获取评论数据失败:', error)
      // 直接返回空数组
      comments.value = []
      return
    }
    
    comments.value = data
  } catch (error) {
    console.error('获取评论数据异常:', error)
    // 直接返回空数组
    comments.value = []
  }
}

const deleteComment = async (id) => {
  try {
    const { data, error } = await supabase
      .from('comments')
      .delete()
      .eq('id', id)
    
    if (error) {
      console.error('删除评论失败:', error)
      return
    }
    
    // 更新本地数据
    comments.value = comments.value.filter(comment => comment.id !== id)
  } catch (error) {
    console.error('删除评论异常:', error)
  }
}

onMounted(() => {
  fetchComments()
})
</script>

<style scoped>
/* 自定义样式 */
</style>