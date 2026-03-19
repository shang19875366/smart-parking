<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">用户评论管理</h2>
    </div>
    <!-- 搜索和筛选 -->
    <div class="flex flex-col md:flex-row gap-4 mb-6">
      <div class="flex-1 relative">
        <input 
          type="text" 
          placeholder="搜索评论..." 
          class="w-full px-4 py-2 pl-10 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
        >
        <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">🔍</span>
      </div>
      <div class="flex gap-4">
        <select class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">
          <option value="">全部停车场</option>
          <option value="1">中央商场停车场</option>
          <option value="2">国贸中心停车场</option>
          <option value="3">三里屯SOHO停车场</option>
        </select>
        <button class="px-4 py-2 bg-secondary text-white rounded-lg hover:bg-gray-700">
          筛选
        </button>
      </div>
    </div>
    <!-- 评论列表 -->
    <div class="space-y-4">
      <div v-for="comment in comments" :key="comment.id" class="p-4 border border-gray-200 dark:border-gray-600 rounded-lg">
        <div class="flex justify-between items-start mb-2">
          <div>
            <h4 class="font-medium text-gray-800 dark:text-white">{{ comment.user_name }}</h4>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ comment.created_at }}</p>
          </div>
          <div class="flex gap-2">
            <button class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600" @click="deleteComment(comment.id)">删除</button>
          </div>
        </div>
        <p class="text-gray-600 dark:text-gray-300 mb-2">{{ comment.content }}</p>
        <div class="text-sm text-gray-500 dark:text-gray-400">
          停车场：{{ comment.parking_name || '未知' }}
        </div>
      </div>
    </div>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ comments.length }} 条记录</p>
      <div class="flex gap-2">
        <button class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">上一页</button>
        <button class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded bg-primary text-white">1</button>
        <button class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">2</button>
        <button class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">3</button>
        <button class="px-3 py-1 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">下一页</button>
      </div>
    </div>
  </div>
</template>

<script>
import { supabase } from '../../services/supabase'

export default {
  name: 'BComment',
  data() {
    return {
      comments: []
    }
  },
  mounted() {
    this.fetchComments()
  },
  methods: {
    async fetchComments() {
      try {
        const { data, error } = await supabase
          .from('comments')
          .select('*')
        
        if (error) {
          console.error('获取评论数据失败:', error)
          // 直接返回空数组
          this.comments = []
          return
        }
        
        this.comments = data
      } catch (error) {
        console.error('获取评论数据异常:', error)
        // 直接返回空数组
        this.comments = []
      }
    },
    async deleteComment(id) {
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
        this.comments = this.comments.filter(comment => comment.id !== id)
      } catch (error) {
        console.error('删除评论异常:', error)
      }
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>