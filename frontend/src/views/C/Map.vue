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
  </div>
</template>

<script>
import { supabase } from '../../services/supabase'

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
      }
    }
  },
  mounted() {
    this.initMap()
    this.fetchParkingLots()
  },
  methods: {
    async fetchParkingLots() {
      try {
        const { data, error } = await supabase
          .from('parking_lots')
          .select('*')
          .eq('status', 'active')
        
        if (error) {
          console.error('获取停车场数据失败:', error)
          // 使用模拟数据作为 fallback
          this.useMockData()
          return
        }
        
        // 计算距离并排序
        this.parkingLots = data.map(parking => {
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
        }).sort((a, b) => a.distance - b.distance)
        
        this.addMarkers()
      } catch (error) {
        console.error('获取停车场数据异常:', error)
        this.useMockData()
      }
    },
    useMockData() {
      // 模拟数据
      this.parkingLots = [
        {
          id: 1,
          name: '中央商场停车场',
          address: '北京市朝阳区建国路88号',
          latitude: 39.9042,
          longitude: 116.4074,
          fee: 10,
          distance: 500
        },
        {
          id: 2,
          name: '国贸中心停车场',
          address: '北京市朝阳区建国门外大街1号',
          latitude: 39.9075,
          longitude: 116.4668,
          fee: 15,
          distance: 1200
        },
        {
          id: 3,
          name: '三里屯SOHO停车场',
          address: '北京市朝阳区三里屯路19号',
          latitude: 39.9342,
          longitude: 116.4531,
          fee: 12,
          distance: 2000
        },
        {
          id: 4,
          name: '朝阳公园停车场',
          address: '北京市朝阳区朝阳公园路1号',
          latitude: 39.9388,
          longitude: 116.4869,
          fee: 8,
          distance: 3500
        },
        {
          id: 5,
          name: '北京SKP停车场',
          address: '北京市朝阳区建国路87号',
          latitude: 39.9047,
          longitude: 116.4652,
          fee: 20,
          distance: 800
        }
      ]
      this.addMarkers()
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
      实际项目中需要引入高德地图SDK并初始化
      this.map = new AMap.Map('mapContainer', {
        center: [this.userLocation.longitude, this.userLocation.latitude],
        zoom: 15
      })
    },
    addMarkers() {
      // 模拟添加停车场标记
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
    }
  }
}
</script>

<style scoped>
/* 自定义样式 */
</style>