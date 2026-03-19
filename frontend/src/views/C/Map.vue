<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 顶部搜索栏 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
      <div class="container mx-auto px-4 py-4">
        <div class="flex items-center">
          <div class="flex-1 relative">
            <input 
              type="text" 
              placeholder="搜索停车场..." 
              class="w-full px-4 py-2 pl-10 rounded-lg border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
            >
            <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400">🔍</span>
          </div>
          <button class="ml-4 px-4 py-2 bg-primary text-white rounded-lg hover:bg-blue-600">
            搜索
          </button>
        </div>
      </div>
    </header>
    <!-- 地图容器 -->
    <div id="mapContainer" class="w-full h-[calc(100vh-160px)]"></div>
    <!-- 底部信息卡片 -->
    <div class="fixed bottom-20 left-0 right-0 px-4">
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow-lg p-4">
        <h3 class="text-lg font-semibold mb-2 text-gray-800 dark:text-white">附近停车场</h3>
        <div class="space-y-3 max-h-60 overflow-y-auto">
          <div 
            v-for="parking in parkingLots" 
            :key="parking.id"
            class="flex items-center p-3 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-700 cursor-pointer"
            @click="showParkingDetail(parking)"
          >
            <div class="text-2xl mr-3">🅿️</div>
            <div class="flex-1">
              <h4 class="font-medium text-gray-800 dark:text-white">{{ parking.name }}</h4>
              <p class="text-sm text-gray-600 dark:text-gray-400">{{ parking.address }}</p>
              <p class="text-sm text-primary">{{ parking.distance }}米 | {{ parking.fee }}元/小时</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- 上报停车场信息弹窗 -->
    <div v-if="showReportModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white dark:bg-gray-800 rounded-lg shadow-xl p-6 w-full max-w-md">
        <div class="flex justify-between items-center mb-6">
          <h2 class="text-xl font-bold text-gray-800 dark:text-white">上报停车场信息</h2>
          <button @click="showReportModal = false" class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200">
            ×
          </button>
        </div>
        <form @submit.prevent="submitReport">
          <div class="mb-4">
            <label class="block text-gray-700 dark:text-gray-300 mb-2">停车场名称</label>
            <input 
              type="text" 
              v-model="form.name" 
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
              placeholder="请输入停车场名称"
              required
            >
          </div>
          <div class="mb-4">
            <label class="block text-gray-700 dark:text-gray-300 mb-2">地址</label>
            <input 
              type="text" 
              v-model="form.address" 
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
              placeholder="请输入详细地址"
              required
            >
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
            <div>
              <label class="block text-gray-700 dark:text-gray-300 mb-2">纬度</label>
              <input 
                type="number" 
                v-model="form.latitude" 
                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
                placeholder="请输入纬度"
                step="0.0001"
                required
              >
            </div>
            <div>
              <label class="block text-gray-700 dark:text-gray-300 mb-2">经度</label>
              <input 
                type="number" 
                v-model="form.longitude" 
                class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
                placeholder="请输入经度"
                step="0.0001"
                required
              >
            </div>
          </div>
          <div class="mb-4">
            <label class="block text-gray-700 dark:text-gray-300 mb-2">收费标准（元/小时）</label>
            <input 
              type="number" 
              v-model="form.fee" 
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
              placeholder="请输入收费标准"
              step="0.5"
              required
            >
          </div>
          <div class="mb-6">
            <label class="block text-gray-700 dark:text-gray-300 mb-2">联系电话</label>
            <input 
              type="tel" 
              v-model="form.phone" 
              class="w-full px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200"
              placeholder="请输入联系电话"
            >
          </div>
          <div class="flex justify-center gap-4">
            <button type="button" @click="showReportModal = false" class="px-6 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-800 dark:text-gray-200 hover:bg-gray-100 dark:hover:bg-gray-600">
              取消
            </button>
            <button type="submit" class="px-6 py-2 bg-primary text-white rounded-lg hover:bg-blue-600">
              提交上报
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { supabase } from '../../services/supabase'
import markerIcon from '@/assets/mark_r.png'

export default {
  name: 'CMap',
  data() {
    return {
      map: null,
      markers: [],
      parkingLots: [],
      userLocation: {
        latitude: 39.9042,
        longitude: 116.4074
      },
      showReportModal: false,
      form: {
        name: '',
        address: '',
        latitude: '',
        longitude: '',
        fee: '',
        phone: ''
      }
    }
  },
  mounted() {
    this.getUserLocation()
  },
  methods: {
    getUserLocation() {
      // 获取用户当前位置
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
          (position) => {
            this.userLocation = {
              latitude: position.coords.latitude,
              longitude: position.coords.longitude
            }
            this.initMap()
            this.fetchParkingLots()
          },
          (error) => {
            console.error('获取位置失败:', error)
            // 使用默认位置
            this.initMap()
            this.fetchParkingLots()
          }
        )
      } else {
        console.error('浏览器不支持地理定位')
        // 使用默认位置
        this.initMap()
        this.fetchParkingLots()
      }
    },
    async fetchParkingLots() {
      try {
        const { data, error } = await supabase
          .from('parking_lots')
          .select('*')
          .eq('status', 'active')
        
        if (error) {
          console.error('获取停车场数据失败:', error)
          // 直接返回空数组
          this.parkingLots = []
          return
        }
        
        // 计算距离并过滤5公里范围内的停车场
        const maxDistance = 5000; // 5公里
        this.parkingLots = data
          .map(parking => {
            const distance = this.calculateDistance(
              this.userLocation.latitude,
              this.userLocation.longitude,
              parking.latitude,
              parking.longitude
            )
            return {
              ...parking,
              distance: Math.round(distance)
            }
          })
          .filter(parking => parking.distance <= maxDistance)
          .sort((a, b) => a.distance - b.distance)
        
        this.addMarkers()
      } catch (error) {
        console.error('获取停车场数据异常:', error)
        // 直接返回空数组
        this.parkingLots = []
      }
    },
    calculateDistance(lat1, lon1, lat2, lon2) {
      // 计算两点之间的距离（米）
      const R = 6371e3; // 地球半径（米）
      const φ1 = lat1 * Math.PI / 180;
      const φ2 = lat2 * Math.PI / 180;
      const Δφ = (lat2 - lat1) * Math.PI / 180;
      const Δλ = (lon2 - lon1) * Math.PI / 180;

      const a = Math.sin(Δφ/2) * Math.sin(Δφ/2) +
              Math.cos(φ1) * Math.cos(φ2) *
              Math.sin(Δλ/2) * Math.sin(Δλ/2);
      const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));

      return R * c;
    },
    initMap() {
      // 模拟高德地图初始化
      console.log('初始化地图')
    //   实际项目中需要引入高德地图SDK并初始化
      this.map = new AMap.Map('mapContainer', {
        center: [this.userLocation.longitude, this.userLocation.latitude],
        zoom: 15,
        // 添加缩放控件
        zoomControl: true,
        // 添加定位控件
        resizeEnable: true
      })
      
      // 添加用户位置标记
      const userMarker = new AMap.Marker({
        position: [this.userLocation.longitude, this.userLocation.latitude],
        title: '我的位置',
        icon: markerIcon,
        map: this.map
      })
      this.markers.push(userMarker)
      
      // 添加定位控件
      const geolocation = new AMap.Geolocation({
        enableHighAccuracy: true, // 是否使用高精度定位，默认:true
        timeout: 10000, // 超过10秒后停止定位，默认：5s
        buttonPosition: 'RB', // 定位按钮的位置
        buttonOffset: new AMap.Pixel(10, 20), // 定位按钮的偏移量
        zoomToAccuracy: true, // 定位成功后是否自动调整地图视野到定位点
        showCircle: true // 定位成功后用圆圈表示定位精度范围，默认：true
      })
      this.map.addControl(geolocation)
      
      // 定位成功回调
      geolocation.on('complete', (data) => {
        this.userLocation = {
          latitude: data.position.getLat(),
          longitude: data.position.getLng()
        }
        // 更新用户位置标记
        userMarker.setPosition([this.userLocation.longitude, this.userLocation.latitude])
        // 重新获取停车场数据
        this.fetchParkingLots()
      })
      
      // 定位失败回调
      geolocation.on('error', (error) => {
        console.error('定位失败:', error)
      })
      
      // 添加地图点击事件监听
      this.map.on('click', (e) => {
        // 自动填充经纬度
        this.form.latitude = e.lnglat.getLat()
        this.form.longitude = e.lnglat.getLng()
        // 显示上报表单
        this.showReportModal = true
      })
    },
    addMarkers() {
      // 清除旧的标记（保留用户位置标记）
      this.markers.forEach((marker, index) => {
        if (index > 0) { // 保留第一个标记（用户位置）
          marker.setMap(null)
        }
      })
      this.markers = this.markers.slice(0, 1) // 只保留用户位置标记
      
      // 添加停车场标记
      this.parkingLots.forEach(parking => {
        console.log('添加标记:', parking.name)
        // 实际项目中需要使用高德地图API添加标记
        const marker = new AMap.Marker({
          position: [parking.longitude, parking.latitude],
          title: parking.name,
          map: this.map
        })
        this.markers.push(marker)
      })
    },
    showParkingDetail(parking) {
      // 跳转到停车场详情页
      this.$router.push(`/c/detail/${parking.id}`)
    },
    async submitReport() {
      try {
        const { data, error } = await supabase
          .from('user_reports')
          .insert({
            name: this.form.name,
            address: this.form.address,
            latitude: parseFloat(this.form.latitude),
            longitude: parseFloat(this.form.longitude),
            fee: parseFloat(this.form.fee),
            phone: this.form.phone,
            user_name: '测试用户', // 实际项目中应该从认证系统获取
            status: 'pending'
          })
          .select()
        
        if (error) {
          console.error('提交上报失败:', error)
          alert('提交失败，请重试')
          return
        }
        
        // 成功提示
        alert('上报成功，等待审核')
        // 重置表单并关闭弹窗
        this.resetForm()
        this.showReportModal = false
        // 重新获取停车场数据
        this.fetchParkingLots()
      } catch (error) {
        console.error('提交上报异常:', error)
        alert('提交失败，请重试')
      }
    },
    resetForm() {
      this.form = {
        name: '',
        address: '',
        latitude: '',
        longitude: '',
        fee: '',
        phone: ''
      }
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>