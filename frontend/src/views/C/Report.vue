<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 顶部导航 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
      <div class="container mx-auto px-4 py-4 flex items-center">
        <button @click="$router.back()" class="mr-4">
          <span class="text-xl">←</span>
        </button>
        <h1 class="text-xl font-bold text-gray-800 dark:text-white">上报停车场信息</h1>
      </div>
    </header>
    <!-- 表单区域 -->
    <section class="bg-white dark:bg-gray-800 p-6">
      <form @submit.prevent="submitReport">
        <div class="mb-6">
          <label class="block text-gray-700 dark:text-gray-300 mb-2">停车场名称</label>
          <input 
            type="text" 
            v-model="form.name" 
            class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
            placeholder="请输入停车场名称"
            required
          >
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 dark:text-gray-300 mb-2">地址</label>
          <input 
            type="text" 
            v-model="form.address" 
            class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
            placeholder="请输入详细地址"
            required
          >
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-2">纬度</label>
            <input 
              type="number" 
              v-model="form.latitude" 
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
              placeholder="请输入纬度"
              step="0.000001"
              required
            >
          </div>
          <div>
            <label class="block text-gray-700 dark:text-gray-300 mb-2">经度</label>
            <input 
              type="number" 
              v-model="form.longitude" 
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
              placeholder="请输入经度"
              step="0.000001"
              required
            >
          </div>
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 dark:text-gray-300 mb-2">收费标准（元/小时）</label>
          <input 
            type="number" 
            v-model="form.fee" 
            class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
            placeholder="请输入收费标准"
            step="0.5"
            required
          >
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 dark:text-gray-300 mb-2">联系电话</label>
          <input 
            type="tel" 
            v-model="form.phone" 
            class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
            placeholder="请输入联系电话"
          >
        </div>
        <div class="mb-6">
          <label class="block text-gray-700 dark:text-gray-300 mb-2">备注</label>
          <textarea 
            v-model="form.remark" 
            class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200 resize-none"
            rows="4"
            placeholder="请输入其他备注信息"
          ></textarea>
        </div>
        <div class="flex justify-center">
          <button type="submit" class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-blue-600">
            提交上报
          </button>
        </div>
      </form>
    </section>
  </div>
</template>

<script>
import { supabase } from '../../services/supabase'

export default {
  name: 'CReport',
  data() {
    return {
      form: {
        name: '',
        address: '',
        latitude: '',
        longitude: '',
        fee: '',
        phone: '',
        remark: ''
      }
    }
  },
  methods: {
    async submitReport() {
      try {
        // 实际项目中需要提交表单数据到后端
        const { data, error } = await supabase
          .from('user_reports')
          .insert({
            name: this.form.name,
            address: this.form.address,
            latitude: parseFloat(this.form.latitude),
            longitude: parseFloat(this.form.longitude),
            fee: parseFloat(this.form.fee),
            phone: this.form.phone,
            remark: this.form.remark,
            user_name: '测试用户', // 实际项目中应该从认证系统获取
            status: 'pending'
          })
          .select()
        
        if (error) {
          console.error('提交上报失败:', error)
          alert('提交失败，请重试')
          return
        }
        
        // 模拟成功提示
        alert('上报成功，等待审核')
        // 重置表单
        this.form = {
          name: '',
          address: '',
          latitude: '',
          longitude: '',
          fee: '',
          phone: '',
          remark: ''
        }
      } catch (error) {
        console.error('提交上报异常:', error)
        alert('提交失败，请重试')
      }
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>