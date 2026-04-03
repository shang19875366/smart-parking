<template>
  <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-xl font-bold text-gray-800 dark:text-white">审核管理</h2>
    </div>
    <!-- 审核类型选择 -->
    <div class="flex gap-4 mb-6">
      <el-button type="primary">停车场信息审核</el-button>
      <el-button>收费标准审核</el-button>
    </div>
    <!-- 审核列表 -->
    <el-table :data="auditItems" style="width: 100%">
      <el-table-column prop="id" label="ID" />
      <el-table-column label="类型">
        <template #default="scope">
          <el-tag :type="scope.row.type === 'parking' ? 'primary' : 'warning'">
            {{ scope.row.type === 'parking' ? '停车场信息' : '收费标准' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="content" label="内容" />
      <el-table-column prop="user_name" label="上报人" />
      <el-table-column prop="created_at" label="上报时间" />
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
            <el-button v-if="scope.row.status === 'pending'" type="success" size="small" @click="approveAudit(scope.row.id)">通过</el-button>
            <el-button v-if="scope.row.status === 'pending'" type="danger" size="small" @click="rejectAudit(scope.row.id)">拒绝</el-button>
            <el-button type="primary" size="small">查看</el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>
    <!-- 分页 -->
    <div class="flex justify-between items-center mt-6">
      <p class="text-gray-600 dark:text-gray-400">共 {{ auditItems.length }} 条记录</p>
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[10, 20, 50, 100]"
        layout="total, sizes, prev, pager, next, jumper"
        :total="auditItems.length"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '../../services/supabase'

const auditItems = ref([])
const currentPage = ref(1)
const pageSize = ref(10)

const fetchAuditItems = async () => {
  try {
    const { data, error } = await supabase
      .from('audits')
      .select('*')
    
    if (error) {
      console.error('获取审核数据失败:', error)
      // 直接返回空数组
      auditItems.value = []
      return
    }
    
    auditItems.value = data
  } catch (error) {
    console.error('获取审核数据异常:', error)
    // 直接返回空数组
    auditItems.value = []
  }
}

const approveAudit = async (id) => {
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
    const index = auditItems.value.findIndex(item => item.id === id)
    if (index !== -1) {
      auditItems.value[index].status = 'approved'
    }
  } catch (error) {
    console.error('审核通过异常:', error)
  }
}

const rejectAudit = async (id) => {
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
    const index = auditItems.value.findIndex(item => item.id === id)
    if (index !== -1) {
      auditItems.value[index].status = 'rejected'
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
  fetchAuditItems()
})
</script>

<style scoped>
/* 自定义样式 */
</style>