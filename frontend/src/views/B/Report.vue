<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">用户上报管理</h2>
    </div>
    <!-- 搜索和筛选 -->
    <div class="flex flex-col md:flex-row gap-4 mb-6">
      <div class="flex-1">
        <el-input 
          v-model="searchQuery" 
          placeholder="搜索上报信息..." 
          prefix-icon="el-icon-search"
        />
      </div>
      <div class="flex gap-4">
        <el-select v-model="statusFilter" placeholder="状态">
          <el-option label="全部状态" value="" />
          <el-option label="待审核" value="pending" />
          <el-option label="已通过" value="approved" />
          <el-option label="已拒绝" value="rejected" />
        </el-select>
        <el-button type="success">筛选</el-button>
      </div>
    </div>
    <!-- 上报列表 -->
    <el-table :data="reports" style="width: 100%">
      <el-table-column prop="id" label="ID" />
      <el-table-column prop="name" label="停车场名称" />
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
      <el-table-column prop="user_name" label="上报人" />
      <el-table-column label="状态">
        <template #default="scope">
          <el-tag :type="getTagType(scope.row.status)">
            {{ getStatusText(scope.row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作">
        <template #default="scope">
          <div class="flex gap-2">
            <el-button v-if="scope.row.status === 'pending'" type="success" size="small" @click="approveReport(scope.row.id)">通过</el-button>
            <el-button v-if="scope.row.status === 'pending'" type="danger" size="small" @click="rejectReport(scope.row.id)">拒绝</el-button>
            <el-button type="primary" size="small">查看</el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ reports.length }} 条记录</p>
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="reports.length"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../services/supabase'

const reports = ref([])
const searchQuery = ref('')
const statusFilter = ref('')
const currentPage = ref(1)
const pageSize = ref(10)

const fetchReports = async () => {
  try {
    const { data, error } = await supabase
      .from('user_reports')
      .select('*')
    
    if (error) {
      console.error('获取上报数据失败:', error)
      // 直接返回空数组
      reports.value = []
      return
    }
    
    reports.value = data
  } catch (error) {
    console.error('获取上报数据异常:', error)
    // 直接返回空数组
    reports.value = []
  }
}

const approveReport = async (id) => {
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
    const index = reports.value.findIndex(report => report.id === id)
    if (index !== -1) {
      reports.value[index].status = 'approved'
    }
  } catch (error) {
    console.error('审核通过异常:', error)
  }
}

const rejectReport = async (id) => {
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
    const index = reports.value.findIndex(report => report.id === id)
    if (index !== -1) {
      reports.value[index].status = 'rejected'
    }
  } catch (error) {
    console.error('拒绝审核异常:', error)
  }
}

const getTagType = (status) => {
  switch (status) {
    case 'pending': return 'warning'
    case 'approved': return 'success'
    case 'rejected': return 'danger'
    default: return ''
  }
}

const getStatusText = (status) => {
  switch (status) {
    case 'pending': return '待审核'
    case 'approved': return '已通过'
    case 'rejected': return '已拒绝'
    default: return status
  }
}

onMounted(() => {
  fetchReports()
})
</script>

<style scoped>
/* 自定义样式 */
</style>