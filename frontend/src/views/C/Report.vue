<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 顶部导航 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
      <div class="container mx-auto px-4 py-4 flex items-center">
        <el-button @click="router.back()" icon="ArrowLeft" circle></el-button>
        <h1 class="text-xl font-bold text-gray-800 dark:text-white">上报停车场信息</h1>
      </div>
    </header>
    <!-- 表单区域 -->
    <section class="bg-white dark:bg-gray-800 p-6">
      <el-card shadow="hover">
        <el-form @submit.prevent="submitReport" :model="form" label-width="100px">
          <el-form-item label="停车场名称" required>
            <el-input v-model="form.name" placeholder="请输入停车场名称" />
          </el-form-item>
          <el-form-item label="地址" required>
            <el-input v-model="form.address" placeholder="请输入详细地址" />
          </el-form-item>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <el-form-item label="纬度" required>
              <el-input v-model="form.latitude" placeholder="请输入纬度" />
            </el-form-item>
            <el-form-item label="经度" required>
              <el-input v-model="form.longitude" placeholder="请输入经度" />
            </el-form-item>
          </div>
          <el-form-item label="收费标准" required>
            <el-input v-model="form.fee" placeholder="请输入收费标准" />
          </el-form-item>
          <el-form-item label="联系电话">
            <el-input v-model="form.phone" placeholder="请输入联系电话" />
          </el-form-item>
          <el-form-item label="备注">
            <el-input
              v-model="form.remark"
              type="textarea"
              :rows="4"
              placeholder="请输入其他备注信息"
            />
          </el-form-item>
          <el-form-item>
            <div class="flex justify-center">
              <el-button type="primary" native-type="submit" size="large">
                提交上报
              </el-button>
            </div>
          </el-form-item>
        </el-form>
      </el-card>
    </section>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from '../../services/supabase'

const router = useRouter()

const form = ref({
  name: '',
  address: '',
  latitude: '',
  longitude: '',
  fee: '',
  phone: '',
  remark: ''
})

const submitReport = async () => {
  try {
    // 实际项目中需要提交表单数据到后端
    const { data, error } = await supabase
      .from('user_reports')
      .insert({
        name: form.value.name,
        address: form.value.address,
        latitude: parseFloat(form.value.latitude),
        longitude: parseFloat(form.value.longitude),
        fee: parseFloat(form.value.fee),
        phone: form.value.phone,
        remark: form.value.remark,
        user_name: '测试用户', // 实际项目中应该从认证系统获取
        status: 'pending'
      })
      .select()
    
    if (error) {
      console.error('提交上报失败:', error)
      alert('提交失败，请重试')
      return
    }
    
    // 模拟成功提示
    alert('上报成功，等待审核')
    // 重置表单
    form.value = {
      name: '',
      address: '',
      latitude: '',
      longitude: '',
      fee: '',
      phone: '',
      remark: ''
    }
  } catch (error) {
    console.error('提交上报异常:', error)
    alert('提交失败，请重试')
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>