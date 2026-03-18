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
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ report.user }}</td>
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
                <button v-if="report.status === 'pending'" class="px-2 py-1 bg-success text-white rounded hover:bg-green-600">通过</button>
                <button v-if="report.status === 'pending'" class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600">拒绝</button>
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
export default {
  name: 'BReport',
  data() {
    return {
      reports: [
        {
          id: 1,
          name: '望京SOHO停车场',
          address: '北京市朝阳区望京SOHO T1',
          latitude: 39.9988,
          longitude: 116.4869,
          fee: 12,
          user: '张三',
          status: 'pending'
        },
        {
          id: 2,
          name: '中关村创业大厦停车场',
          address: '北京市海淀区中关村大街1号',
          latitude: 39.9847,
          longitude: 116.3055,
          fee: 15,
          user: '李四',
          status: 'approved'
        },
        {
          id: 3,
          name: '北京西站停车场',
          address: '北京市丰台区莲花池东路',
          latitude: 39.8947,
          longitude: 116.3226,
          fee: 10,
          user: '王五',
          status: 'rejected'
        },
        {
          id: 4,
          name: '朝阳大悦城停车场',
          address: '北京市朝阳区朝阳北路101号',
          latitude: 39.9288,
          longitude: 116.5269,
          fee: 8,
          user: '赵六',
          status: 'pending'
        }
      ]
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>