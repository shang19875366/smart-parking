<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 dark:from-gray-900 dark:to-blue-900">
    <!-- 顶部导航 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm">
      <div class="container mx-auto px-4 py-4 flex justify-between items-center">
        <h1 class="text-2xl font-bold text-primary">智慧停车</h1>
        <div class="flex items-center">
          <router-link to="/c/map" class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600 mr-4">
            查看地图
          </router-link>
          <router-link to="/c/report" class="px-4 py-2 bg-secondary text-white rounded-lg hover:bg-gray-700">
            上报信息
          </router-link>
        </div>
      </div>
    </header>
    <!-- 英雄区域 -->
    <section class="container mx-auto px-4 py-16">
      <div class="flex flex-col md:flex-row items-center justify-between">
        <div class="md:w-1/2 mb-8 md:mb-0">
          <h2 class="text-4xl font-bold mb-4 text-gray-800 dark:text-white">
            智能找车位，轻松停车
          </h2>
          <p class="text-lg text-gray-600 dark:text-gray-300 mb-8">
            实时查看附近停车场位置、收费信息，一键导航，告别停车难问题。
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <router-link to="/c/map" class="px-6 py-3 bg-primary text-white rounded-lg hover:bg-blue-600 text-center">
              立即查找
            </router-link>
            <router-link to="/c/report" class="px-6 py-3 bg-white dark:bg-gray-800 text-primary border border-primary rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 text-center">
              上报信息
            </router-link>
          </div>
        </div>
        <div class="md:w-1/2">
          <img src="../../assets/parking.jpg" alt="智慧停车地图" class="rounded-lg shadow-lg w-full">
        </div>
      </div>
    </section>
    <!-- 功能特点 -->
    <section class="bg-white dark:bg-gray-800 py-16">
      <div class="container mx-auto px-4">
        <h3 class="text-2xl font-bold mb-12 text-center text-gray-800 dark:text-white">核心功能</h3>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <!-- 功能1 -->
          <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg shadow-md">
            <div class="text-4xl mb-4">🗺️</div>
            <h4 class="text-xl font-semibold mb-2 text-gray-800 dark:text-white">地图导航</h4>
            <p class="text-gray-600 dark:text-gray-300">
              实时显示附近5公里内的停车场位置，一键导航至目的地。
            </p>
          </div>
          <!-- 功能2 -->
          <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg shadow-md">
            <div class="text-4xl mb-4">💰</div>
            <h4 class="text-xl font-semibold mb-2 text-gray-800 dark:text-white">收费透明</h4>
            <p class="text-gray-600 dark:text-gray-300">
              详细展示停车场收费标准，避免停车费用纠纷。
            </p>
          </div>
          <!-- 功能3 -->
          <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg shadow-md">
            <div class="text-4xl mb-4">📋</div>
            <h4 class="text-xl font-semibold mb-2 text-gray-800 dark:text-white">信息上报</h4>
            <p class="text-gray-600 dark:text-gray-300">
              支持用户上报新停车场位置和收费信息，共同完善数据库。
            </p>
          </div>
          <!-- 功能4 -->
          <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg shadow-md">
            <div class="text-4xl mb-4">💬</div>
            <h4 class="text-xl font-semibold mb-2 text-gray-800 dark:text-white">用户评论</h4>
            <p class="text-gray-600 dark:text-gray-300">
              查看其他用户的评论，了解停车场真实情况。
            </p>
          </div>
          <!-- 功能5 -->
          <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg shadow-md">
            <div class="text-4xl mb-4">🔍</div>
            <h4 class="text-xl font-semibold mb-2 text-gray-800 dark:text-white">智能搜索</h4>
            <p class="text-gray-600 dark:text-gray-300">
              根据位置、价格等条件筛选合适的停车场。
            </p>
          </div>
          <!-- 功能6 -->
          <div class="bg-gray-50 dark:bg-gray-700 p-6 rounded-lg shadow-md">
            <div class="text-4xl mb-4">🚗</div>
            <h4 class="text-xl font-semibold mb-2 text-gray-800 dark:text-white">实时更新</h4>
            <p class="text-gray-600 dark:text-gray-300">
              停车场状态实时更新，避免白跑一趟。
            </p>
          </div>
        </div>
      </div>
    </section>
    <!-- 底部信息 -->
    <footer class="bg-gray-100 dark:bg-gray-900 py-8">
      <div class="container mx-auto px-4 text-center">
        <p class="text-gray-600 dark:text-gray-400">© 2026 智慧停车系统 | 让停车更智能</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'CHome'
}
</script>

<style scoped>
/* 自定义样式 */
</style>