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
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ item.user }}</td>
            <td class="px-4 py-3 border-b border-gray-200 dark:border-gray-600">{{ item.time }}</td>
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
                <button v-if="item.status === 'pending'" class="px-2 py-1 bg-success text-white rounded hover:bg-green-600">通过</button>
                <button v-if="item.status === 'pending'" class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600">拒绝</button>
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
export default {
  name: 'BAudit',
  data() {
    return {
      auditItems: [
        {
          id: 1,
          type: 'parking',
          content: '望京SOHO停车场 - 北京市朝阳区望京SOHO T1',
          user: '张三',
          time: '2026-03-18 10:00',
          status: 'pending'
        },
        {
          id: 2,
          type: 'fee',
          content: '中央商场停车场 - 收费标准变更为12元/小时',
          user: '李四',
          time: '2026-03-18 09:30',
          status: 'pending'
        },
        {
          id: 3,
          type: 'parking',
          content: '中关村创业大厦停车场 - 北京市海淀区中关村大街1号',
          user: '王五',
          time: '2026-03-17 16:00',
          status: 'approved'
        },
        {
          id: 4,
          type: 'fee',
          content: '国贸中心停车场 - 收费标准变更为18元/小时',
          user: '赵六',
          time: '2026-03-17 14:30',
          status: 'rejected'
        },
        {
          id: 5,
          type: 'parking',
          content: '朝阳大悦城停车场 - 北京市朝阳区朝阳北路101号',
          user: '孙七',
          time: '2026-03-16 11:00',
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