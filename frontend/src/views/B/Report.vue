<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">用户上报管理</h2>
    </div>
    <!-- 搜索和筛选 -->
    <div class="flex flex-col md:flex-row gap-4 mb-6">
      <div class="flex-1 relative">
        <input 
          type="text" 
          placeholder="搜索上报信息..." 
          class="w-full px-4 py-2 pl-10 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
        >
        <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">🔍</span>
      </div>
      <div class="flex gap-4">
        <select class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">
          <option value="">全部状态</option>
          <option value="pending">待审核</option>
          <option value="approved">已通过</option>
          <option value="rejected">已拒绝</option>
        </select>
        <button class="px-4 py-2 bg-secondary text-white rounded-lg hover:bg-gray-700">
          筛选
        </button>
      </div>
    </div>
    <!-- 上报列表 -->
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead class="bg-gray-100 dark:bg-gray-700">
          <tr>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">ID</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">停车场名称</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">地址</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">经纬度</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">收费标准</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">上报人</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">状态</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="report in reports" :key="report.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.id }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.name }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.address }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.latitude }}, {{ report.longitude }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.fee }}元/小时</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.user_name }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <span :class="{
                'text-warning': report.status === 'pending',
                'text-success': report.status === 'approved',
                'text-danger': report.status === 'rejected'
              }">
                {{ report.status === 'pending' ? '待审核' : report.status === 'approved' ? '已通过' : '已拒绝' }}
              </span>
            </td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <div class="flex gap-2">
                <button v-if="report.status === 'pending'" class="px-2 py-1 bg-success text-white rounded hover:bg-green-600" @click="approveReport(report.id)">通过</button>
                <button v-if="report.status === 'pending'" class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600" @click="rejectReport(report.id)">拒绝</button>
                <button class="px-2 py-1 bg-primary text-white rounded hover:bg-blue-600">查看</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ reports.length }} 条记录</p>
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
  name: 'BReport',
  data() {
    return {
      reports: []
    }
  },
  mounted() {
    this.fetchReports()
  },
  methods: {
    async fetchReports() {
      try {
        const { data, error } = await supabase
          .from('user_reports')
          .select('*')
        
        if (error) {
          console.error('获取上报数据失败:', error)
          // 直接返回空数组
          this.reports = []
          return
        }
        
        this.reports = data
      } catch (error) {
        console.error('获取上报数据异常:', error)
        // 直接返回空数组
        this.reports = []
      }
    },
    async approveReport(id) {
      try {
        const { data, error } = await supabase
          .from('user_reports')
          .update({ status: 'approved' })
          .eq('id', id)
          .select()
        
        if (error) {
          console.error('审核通过失败:', error)
          return
        }
        
        // 更新本地数据
        const index = this.reports.findIndex(report => report.id === id)
        if (index !== -1) {
          this.reports[index].status = 'approved'
        }
      } catch (error) {
        console.error('审核通过异常:', error)
      }
    },
    async rejectReport(id) {
      try {
        const { data, error } = await supabase
          .from('user_reports')
          .update({ status: 'rejected' })
          .eq('id', id)
          .select()
        
        if (error) {
          console.error('拒绝审核失败:', error)
          return
        }
        
        // 更新本地数据
        const index = this.reports.findIndex(report => report.id === id)
        if (index !== -1) {
          this.reports[index].status = 'rejected'
        }
      } catch (error) {
        console.error('拒绝审核异常:', error)
      }
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>