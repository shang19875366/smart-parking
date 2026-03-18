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
            <h4 class="font-medium text-gray-800 dark:text-white">{{ comment.user }}</h4>
            <p class="text-sm text-gray-500 dark:text-gray-400">{{ comment.date }}</p>
          </div>
          <div class="flex gap-2">
            <button class="px-2 py-1 bg-danger text-white rounded hover:bg-red-600">删除</button>
          </div>
        </div>
        <p class="text-gray-600 dark:text-gray-300 mb-2">{{ comment.content }}</p>
        <div class="text-sm text-gray-500 dark:text-gray-400">
          停车场：{{ comment.parkingName }}
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
export default {
  name: 'BComment',
  data() {
    return {
      comments: [
        {
          id: 1,
          user: '张三',
          date: '2026-03-15',
          content: '停车场环境不错，收费合理，车位充足。',
          parkingName: '中央商场停车场'
        },
        {
          id: 2,
          user: '李四',
          date: '2026-03-10',
          content: '位置很好找，就是高峰期有点挤，建议错峰出行。',
          parkingName: '国贸中心停车场'
        },
        {
          id: 3,
          user: '王五',
          date: '2026-03-05',
          content: '收费标准有变化，现在是10元/小时，之前是8元。',
          parkingName: '中央商场停车场'
        },
        {
          id: 4,
          user: '赵六',
          date: '2026-03-01',
          content: '停车场卫生状况不太好，希望能改进。',
          parkingName: '三里屯SOHO停车场'
        },
        {
          id: 5,
          user: '孙七',
          date: '2026-02-28',
          content: '服务态度很好，车位引导员很专业。',
          parkingName: '国贸中心停车场'
        }
      ]
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>