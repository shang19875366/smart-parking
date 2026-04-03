<template>
  <div class="flex h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 侧边栏 -->
    <aside class="w-64 bg-white dark:bg-gray-800 shadow-md">
      <div class="p-4 border-b border-gray-200 dark:border-gray-700">
        <h1 class="text-xl font-bold text-primary">智慧停车管理后台</h1>
      </div>
      <nav class="p-4">
        <ul>
          <li class="mb-2">
            <router-link to="/b/parking" class="flex items-center p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
              <span class="mr-3">🅿️</span>
              <span>停车场管理</span>
            </router-link>
          </li>
          <li class="mb-2">
            <router-link to="/b/report" class="flex items-center p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
              <span class="mr-3">📋</span>
              <span>用户上报管理</span>
            </router-link>
          </li>
          <li class="mb-2">
            <router-link to="/b/comment" class="flex items-center p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
              <span class="mr-3">💬</span>
              <span>用户评论管理</span>
            </router-link>
          </li>
          <li class="mb-2">
            <router-link to="/b/audit" class="flex items-center p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700">
              <span class="mr-3">✅</span>
              <span>审核管理</span>
            </router-link>
          </li>
        </ul>
      </nav>
    </aside>
    <!-- 主内容区 -->
    <div class="flex-1 flex flex-col">
      <!-- 顶部导航 -->
      <header class="bg-white dark:bg-gray-800 shadow-sm">
        <div class="flex justify-between items-center p-4">
          <h2 class="text-lg font-medium">{{ currentRoute.meta.title || '管理后台' }}</h2>
          <div class="flex items-center">
            <button class="px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600">
              退出登录
            </button>
          </div>
        </div>
      </header>
      <!-- 内容区域 -->
      <main class="flex-1 p-6 overflow-auto">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const currentRoute = computed(() => route)
</script>

<style scoped>
/* 自定义样式 */
</style>