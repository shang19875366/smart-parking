<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">停车场管理</h2>
      <button class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600">
        添加停车场
      </button>
    </div>
    <!-- 搜索和筛选 -->
    <div class="flex flex-col md:flex-row gap-4 mb-6">
      <div class="flex-1 relative">
        <input 
          type="text" 
          placeholder="搜索停车场..." 
          class="w-full px-4 py-2 pl-10 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
        >
        <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">🔍</span>
      </div>
      <div class="flex gap-4">
        <select class="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200">
          <option value="">全部</option>
          <option value="active">启用</option>
          <option value="inactive">禁用</option>
        </select>
        <button class="px-4 py-2 bg-secondary text-white rounded-lg hover:bg-gray-700">
          筛选
        </button>
      </div>
    </div>
    <!-- 停车场列表 -->
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead class="bg-gray-100 dark:bg-gray-700">
          <tr>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">ID</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">名称</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">地址</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">经纬度</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">收费标准</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">状态</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="parking in parkingLots" :key="parking.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ parking.id }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ parking.name }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ parking.address }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ parking.latitude }}, {{ parking.longitude }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ parking.fee }}元/小时</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <span :class="parking.status === 'active' ? 'text-success' : 'text-danger'">
                {{ parking.status === 'active' ? '启用' : '禁用' }}
              </span>
            </td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <div class="flex gap-2">
                <button class="px-2 py-1 bg-primary text-white rounded hover:bg-blue-600">编辑</button>
                <button class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600">删除</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ parkingLots.length }} 条记录</p>
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
  name: 'BParking',
  data() {
    return {
      parkingLots: []
    }
  },
  mounted() {
    this.fetchParkingLots()
  },
  methods: {
    async fetchParkingLots() {
      try {
        const { data, error } = await supabase
          .from('parking_lots')
          .select('*')
        
        if (error) {
          console.error('获取停车场数据失败:', error)
          // 直接返回空数组
          this.parkingLots = []
          return
        }
        
        this.parkingLots = data
      } catch (error) {
        console.error('获取停车场数据异常:', error)
        // 直接返回空数组
        this.parkingLots = []
      }
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>