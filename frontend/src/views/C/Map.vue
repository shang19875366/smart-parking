<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <!-- 顶部搜索栏 -->
    <header class="bg-white dark:bg-gray-800 shadow-sm sticky top-0 z-10">
      <div class="container mx-auto px-4 py-4">
        <div class="flex items-center">
          <el-input
            v-model="searchQuery"
            placeholder="搜索停车场..."
            prefix-icon="Search"
            class="flex-1 mr-4"
          />
          <el-button type="primary" @click="handleSearch">搜索</el-button>
        </div>
      </div>
    </header>
    <!-- 地图容器 -->
    <div id="mapContainer" class="w-full h-[calc(100vh-160px)]"></div>
    <!-- 底部信息卡片 -->
    <div class="fixed bottom-20 left-0 right-0 px-4">
      <el-card shadow="hover" class="bg-white dark:bg-gray-800">
        <template #header>
          <div class="flex justify-between items-center">
            <h3 class="text-lg font-semibold text-gray-800 dark:text-white">
              附近停车场
            </h3>
            <span class="text-sm text-gray-600 dark:text-gray-400">{{ parkingLots.length }} 个</span>
          </div>
        </template>
        <div class="space-y-3 max-h-60 overflow-y-auto">
          <el-card
            v-for="parking in parkingLots"
            :key="parking.id"
            shadow="hover"
            class="cursor-pointer"
            @click="showParkingDetail(parking)"
          >
            <div class="flex items-center">
              <div class="text-2xl mr-3">🅿️</div>
              <div class="flex-1">
                <h4 class="font-medium text-gray-800 dark:text-white">
                  {{ parking.name }}
                </h4>
                <p class="text-sm text-gray-600 dark:text-gray-400">
                  {{ parking.address }}
                </p>
                <p class="text-sm text-primary">
                  {{ parking.distance }}米 | {{ parking.fee }}元/小时
                </p>
              </div>
            </div>
          </el-card>
          <div v-if="parkingLots.length === 0" class="text-center py-4 text-gray-500">
            附近暂无停车场
          </div>
        </div>
      </el-card>
    </div>
    <!-- 上报停车场信息弹窗 -->
    <el-dialog
      v-model="showReportModal"
      title="上报停车场信息"
      width="90%"
      :max-width="'500px'"
    >
      <el-form @submit.prevent="submitReport" :model="form" label-width="80px">
        <el-form-item label="停车场名称" required>
          <el-input v-model="form.name" placeholder="请输入停车场名称" />
        </el-form-item>
        <el-form-item label="地址" required>
          <el-input v-model="form.address" placeholder="请输入详细地址" />
        </el-form-item>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
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
        <el-form-item>
          <div class="flex justify-center gap-4">
            <el-button @click="showReportModal = false">取消</el-button>
            <el-button type="primary" native-type="submit">提交上报</el-button>
          </div>
        </el-form-item>
      </el-form>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { supabase } from "../../services/supabase";
import AMapLoader from "@amap/amap-jsapi-loader";

const router = useRouter()

const map = ref(null)
const markers = ref([])
const parkingLots = ref([])
const userLocation = ref({
  latitude: 39.9042,
  longitude: 116.4074,
})
const showReportModal = ref(false)
const searchQuery = ref('')
const form = ref({
  name: "",
  address: "",
  latitude: "",
  longitude: "",
  fee: "",
  phone: "",
})

const getUserLocation = () => {
  // 获取用户当前位置
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        userLocation.value = {
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
        };
        initMap();
        fetchParkingLots();
      },
      (error) => {
        console.error("获取位置失败:", error);
        // 使用默认位置
        initMap();
        fetchParkingLots();
      },
    );
  } else {
    console.error("浏览器不支持地理定位");
    // 使用默认位置
    initMap();
    fetchParkingLots();
  }
}

const fetchParkingLots = async () => {
  try {
    const { data, error } = await supabase
      .from("parking_lots")
      .select("*")
      .eq("status", "active");

    if (error) {
      console.error("获取停车场数据失败:", error);
      // 直接返回空数组
      parkingLots.value = [];
      return;
    }

    // 计算距离并过滤5公里范围内的停车场
    const maxDistance = 5000; // 5公里
    parkingLots.value = data
      .map((parking) => {
        const distance = calculateDistance(
          userLocation.value.latitude,
          userLocation.value.longitude,
          parking.latitude,
          parking.longitude,
        );
        return {
          ...parking,
          distance: Math.round(distance),
        };
      })
      .filter((parking) => parking.distance <= maxDistance)
      .sort((a, b) => a.distance - b.distance);

    addMarkers();
  } catch (error) {
    console.error("获取停车场数据异常:", error);
    // 直接返回空数组
    parkingLots.value = [];
  }
}

const calculateDistance = (lat1, lon1, lat2, lon2) => {
  // 计算两点之间的距离（米）
  const R = 6371e3; // 地球半径（米）
  const φ1 = (lat1 * Math.PI) / 180;
  const φ2 = (lat2 * Math.PI) / 180;
  const Δφ = ((lat2 - lat1) * Math.PI) / 180;
  const Δλ = ((lon2 - lon1) * Math.PI) / 180;

  const a =
    Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  return R * c;
}

const initMap = () => {
  console.log("开始初始化地图");
  
  // 检查地图容器是否存在
  const mapContainer = document.getElementById('mapContainer');
  if (!mapContainer) {
    console.error("地图容器不存在");
    return;
  }
  
  console.log("地图容器存在，开始加载地图API");
  
  // 设置安全密钥
  window._AMapSecurityConfig = {
    securityJsCode: "9f5f7632cbace5c0f666e119cc3a0573",
  };
  
  // 加载地图API
  AMapLoader.load({
    key: "c65b5c99a7c35a32608b5af07aa7db0c",
    version: "2.0",
    plugins: ["AMap.Scale", "AMap.Geolocation"],
  })
    .then((AMap) => {
      console.log("地图API加载成功");
      
      // 保存 AMap 对象到全局
      window.AMap = AMap;
      
      // 初始化地图
      try {
        map.value = new AMap.Map("mapContainer", {
          center: [userLocation.value.longitude, userLocation.value.latitude],
          zoom: 15,
          zoomControl: true,
          resizeEnable: true,
        });
        console.log("地图初始化成功");
      } catch (error) {
        console.error("地图初始化失败:", error);
        return;
      }
      
      // 添加用户位置标记
      try {
        const userMarker = new AMap.Marker({
          position: [userLocation.value.longitude, userLocation.value.latitude],
          title: "我的位置",
          icon: new AMap.Icon({
            size: new AMap.Size(20, 20),
            image: "https://webapi.amap.com/theme/v1.3/markers/n/mark_r.png",
            imageSize: new AMap.Size(20, 20),
          }),
          map: map.value,
        });
        markers.value.push(userMarker);
        console.log("用户位置标记添加成功");
      } catch (error) {
        console.error("添加用户位置标记失败:", error);
      }
      
      // 添加定位控件
      AMap.plugin(["AMap.Geolocation"], () => {
        console.log("定位插件加载成功");
        
        try {
          const geolocation = new AMap.Geolocation({
            enableHighAccuracy: true,
            timeout: 10000,
            buttonPosition: "RB",
            buttonOffset: new AMap.Pixel(10, 20),
            zoomToAccuracy: true,
            showCircle: true,
          });
          
          map.value.addControl(geolocation);
          console.log("定位控件添加成功");
          
          // 定位成功回调
          geolocation.on("complete", (data) => {
            console.log("定位成功:", data);
            userLocation.value = {
              latitude: data.position.getLat(),
              longitude: data.position.getLng(),
            };
            // 更新用户位置标记
            if (markers.value.length > 0) {
              markers.value[0].setPosition([
                userLocation.value.longitude,
                userLocation.value.latitude,
              ]);
            }
            // 重新获取停车场数据
            fetchParkingLots();
          });
          
          // 定位失败回调
          geolocation.on("error", (error) => {
            console.error("定位失败:", error);
          });
        } catch (error) {
          console.error("初始化定位控件失败:", error);
        }
      });
      
      // 添加地图点击事件监听
      map.value.on("click", (e) => {
        console.log("地图被点击:", e.lnglat);
        // 自动填充经纬度
        form.value.latitude = e.lnglat.getLat();
        form.value.longitude = e.lnglat.getLng();
        // 显示上报表单
        showReportModal.value = true;
      });
      
      // 初始化时添加停车场标记
      addMarkers();
    })
    .catch((e) => {
      console.error("地图API加载失败:", e);
    });
}

const addMarkers = () => {
  // 确保地图已初始化
  if (!map.value || !window.AMap) {
    console.warn("地图未初始化，无法添加标记");
    return;
  }
  
  // 清除旧的标记（保留用户位置标记）
  markers.value.forEach((marker, index) => {
    if (index > 0) {
      // 保留第一个标记（用户位置）
      marker.setMap(null);
    }
  });
  markers.value = markers.value.slice(0, 1); // 只保留用户位置标记

  // 添加停车场标记
  parkingLots.value.forEach((parking) => {
    console.log("添加标记:", parking.name);
    // 使用全局 AMap 对象创建标记
    const marker = new window.AMap.Marker({
      position: [parking.longitude, parking.latitude],
      title: parking.name,
      map: map.value,
    });
    markers.value.push(marker);
  });
}

const showParkingDetail = (parking) => {
  // 跳转到停车场详情页
  router.push(`/c/detail/${parking.id}`);
}

const submitReport = async () => {
  try {
    const { data, error } = await supabase
      .from("user_reports")
      .insert({
        name: form.value.name,
        address: form.value.address,
        latitude: parseFloat(form.value.latitude),
        longitude: parseFloat(form.value.longitude),
        fee: parseFloat(form.value.fee),
        phone: form.value.phone,
        user_name: "测试用户", // 实际项目中应该从认证系统获取
        status: "pending",
      })
      .select();

    if (error) {
      console.error("提交上报失败:", error);
      alert("提交失败，请重试");
      return;
    }

    // 成功提示
    alert("上报成功，等待审核");
    // 重置表单并关闭弹窗
    resetForm();
    showReportModal.value = false;
    // 重新获取停车场数据
    fetchParkingLots();
  } catch (error) {
    console.error("提交上报异常:", error);
    alert("提交失败，请重试");
  }
}

const resetForm = () => {
  form.value = {
    name: "",
    address: "",
    latitude: "",
    longitude: "",
    fee: "",
    phone: "",
  };
}

const handleSearch = () => {
  // 搜索功能实现
  console.log('搜索:', searchQuery.value);
  // 这里可以添加搜索逻辑
}

onMounted(() => {
  getUserLocation();
});
</script>

<style scoped>
/* 自定义样式 */
</style>
