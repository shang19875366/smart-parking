<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">审核管理</h2>
    </div>
    <!-- 审核类型选择 -->
    <div class="flex gap-4 mb-6">
      <button class="px-4 py-2 bg-primary text-white rounded-lg">停车场信息审核</button>
      <button class="px-4 py-2 bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200 border border-gray-300 dark:border-gray-600 rounded-lg">收费标准审核</button>
    </div>
    <!-- 审核列表 -->
    <div class="overflow-x-auto">
      <table class="w-full text-left">
        <thead class="bg-gray-100 dark:bg-gray-700">
          <tr>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">ID</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">类型</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">内容</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">上报人</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">上报时间</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">状态</th>
            <th class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in auditItems" :key="item.id" class="hover:bg-gray-50 dark:hover:bg-gray-700">
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ item.id }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <span :class="item.type === 'parking' ? 'text-primary' : 'text-warning'">
                {{ item.type === 'parking' ? '停车场信息' : '收费标准' }}
              </span>
            </td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ item.content }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ item.user_name }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ item.created_at }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <span :class="{
                'text-warning': item.status === 'pending',
                'text-success': item.status === 'approved',
                'text-danger': item.status === 'rejected'
              }">
                {{ item.status === 'pending' ? '待审核' : item.status === 'approved' ? '已通过' : '已拒绝' }}
              </span>
            </td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">
              <div class="flex gap-2">
                <button v-if="item.status === 'pending'" class="px-2 py-1 bg-success text-white rounded hover:bg-green-600" @click="approveAudit(item.id)">通过</button>
                <button v-if="item.status === 'pending'" class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600" @click="rejectAudit(item.id)">拒绝</button>
                <button class="px-2 py-1 bg-primary text-white rounded hover:bg-blue-600">查看</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ auditItems.length }} 条记录</p>
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
  name: 'BAudit',
  data() {
    return {
      auditItems: []
    }
  },
  mounted() {
    this.fetchAuditItems()
  },
  methods: {
    async fetchAuditItems() {
      try {
        const { data, error } = await supabase
          .from('audits')
          .select('*')
        
        if (error) {
          console.error('获取审核数据失败:', error)
          // 直接返回空数组
          this.auditItems = []
          return
        }
        
        this.auditItems = data
      } catch (error) {
        console.error('获取审核数据异常:', error)
        // 直接返回空数组
        this.auditItems = []
      }
    },
    async approveAudit(id) {
      try {
        const { data, error } = await supabase
          .from('audits')
          .update({ status: 'approved' })
          .eq('id', id)
          .select()
        
        if (error) {
          console.error('审核通过失败:', error)
          return
        }
        
        // 更新本地数据
        const index = this.auditItems.findIndex(item => item.id === id)
        if (index !== -1) {
          this.auditItems[index].status = 'approved'
        }
      } catch (error) {
        console.error('审核通过异常:', error)
      }
    },
    async rejectAudit(id) {
      try {
        const { data, error } = await supabase
          .from('audits')
          .update({ status: 'rejected' })
          .eq('id', id)
          .select()
        
        if (error) {
          console.error('拒绝审核失败:', error)
          return
        }
        
        // 更新本地数据
        const index = this.auditItems.findIndex(item => item.id === id)
        if (index !== -1) {
          this.auditItems[index].status = 'rejected'
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