<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">停车场管理</h2>
      <el-button type="primary">添加停车场</el-button>
    </div>
    <!-- 搜索和筛选 -->
    <div class="flex flex-col md:flex-row gap-4 mb-6">
      <div class="flex-1">
        <el-input 
          v-model="searchQuery" 
          placeholder="搜索停车场..." 
          prefix-icon="el-icon-search"
        />
      </div>
      <div class="flex gap-4">
        <el-select v-model="statusFilter" placeholder="状态">
          <el-option label="全部" value="" />
          <el-option label="启用" value="active" />
          <el-option label="禁用" value="inactive" />
        </el-select>
        <el-button type="success">筛选</el-button>
      </div>
    </div>
    <!-- 停车场列表 -->
    <el-table :data="parkingLots" style="width: 100%">
      <el-table-column prop="id" label="ID" />
      <el-table-column prop="name" label="名称" />
      <el-table-column prop="address" label="地址" />
      <el-table-column label="经纬度">
        <template #default="scope">
          {{ scope.row.latitude }}, {{ scope.row.longitude }}
        </template>
      </el-table-column>
      <el-table-column label="收费标准">
        <template #default="scope">
          {{ scope.row.fee }}
        </template>
      </el-table-column>
      <el-table-column label="状态">
        <template #default="scope">
          <el-tag :type="scope.row.status === 'active' ? 'success' : 'danger'">
            {{ scope.row.status === 'active' ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <el-button type="primary" size="small">编辑</el-button>
          <el-button type="danger" size="small">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ parkingLots.length }} 条记录</p>
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="parkingLots.length"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../services/supabase'

const parkingLots = ref([])
const searchQuery = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(10)

const fetchParkingLots = async () => {
  try {
    const { data, error } = await supabase
      .from('parking_lots')
      .select('*')
    
    if (error) {
      console.error('获取停车场数据失败:', error)
      // 直接返回空数组
      parkingLots.value = []
      return
    }
    
    parkingLots.value = data
  } catch (error) {
    console.error('获取停车场数据异常:', error)
    // 直接返回空数组
    parkingLots.value = []
  }
}

onMounted(() => {
  fetchParkingLots()
})
</script>

<style scoped>
/* 自定义样式 */
</style>