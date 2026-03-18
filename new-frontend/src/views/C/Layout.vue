<template>
  <div class="flex flex-col h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 主内容区 -->
    <main class="flex-1 overflow-auto">
      <router-view />
    </main>
    <!-- 底部导航 -->
    <footer class="bg-white dark:bg-gray-800 shadow-md">
      <div class="flex justify-around items-center p-4">
        <router-link to="/c/map" class="flex flex-col items-center">
          <span class="text-2xl mb-1">🗺️</span>
          <span class="text-sm">地图</span>
        </router-link>
        <router-link to="/c/report" class="flex flex-col items-center">
          <span class="text-2xl mb-1">📋</span>
          <span class="text-sm">上报</span>
        </router-link>
        <router-link to="/" class="flex flex-col items-center">
          <span class="text-2xl mb-1">🏠</span>
          <span class="text-sm">首页</span>
        </router-link>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'CLayout'
}
</script>

<style scoped>
/* 自定义样式 */
</style>