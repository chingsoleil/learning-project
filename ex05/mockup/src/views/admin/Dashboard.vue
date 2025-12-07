<template>
  <AdminLayout>
    <!-- Stats Cards -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <BaseCard v-for="stat in stats" :key="stat.label" padding="normal">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm text-gray-600 mb-1">{{ stat.label }}</p>
            <p class="text-3xl font-bold text-gray-900">{{ stat.value }}</p>
            <p class="text-xs mt-1" :class="stat.change >= 0 ? 'text-green-600' : 'text-red-600'">
              {{ stat.change >= 0 ? '↑' : '↓' }} {{ Math.abs(stat.change) }}% 較上月
            </p>
          </div>
          <div class="text-4xl" :class="getStatColor(stat.color)">
            {{ stat.icon }}
          </div>
        </div>
      </BaseCard>
    </div>

    <!-- Charts Row -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
      <!-- Test Trend Chart -->
      <BaseCard>
        <h3 class="text-lg font-semibold text-gray-900 mb-4">近30天測驗趨勢</h3>
        <div class="h-64">
          <canvas ref="trendChart"></canvas>
        </div>
      </BaseCard>

      <!-- Test Type Distribution -->
      <BaseCard>
        <h3 class="text-lg font-semibold text-gray-900 mb-4">測驗類型分布</h3>
        <div class="h-64 flex items-center justify-center">
          <canvas ref="pieChart"></canvas>
        </div>
      </BaseCard>
    </div>

    <!-- Demographics -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
      <!-- Age Distribution -->
      <BaseCard>
        <h3 class="text-lg font-semibold text-gray-900 mb-4">年齡分布</h3>
        <div class="h-64">
          <canvas ref="ageChart"></canvas>
        </div>
      </BaseCard>

      <!-- Gender Distribution -->
      <BaseCard>
        <h3 class="text-lg font-semibold text-gray-900 mb-4">性別分布</h3>
        <div class="h-64 flex items-center justify-center">
          <canvas ref="genderChart"></canvas>
        </div>
      </BaseCard>
    </div>

    <!-- Recent Activity -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Latest Tests -->
      <BaseCard>
        <h3 class="text-lg font-semibold text-gray-900 mb-4">最新完成測驗</h3>
        <div class="space-y-3">
          <div v-for="test in latestTests" :key="test.id" 
               class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex items-center">
              <span class="text-2xl mr-3">{{ test.icon }}</span>
              <div>
                <p class="font-medium text-gray-900">{{ test.userName }}</p>
                <p class="text-sm text-gray-600">{{ test.testName }}</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm text-gray-600">{{ test.time }}</p>
              <span class="text-xs px-2 py-1 bg-green-100 text-green-800 rounded-full">
                已完成
              </span>
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Latest Consultations -->
      <BaseCard>
        <h3 class="text-lg font-semibold text-gray-900 mb-4">最新諮詢請求</h3>
        <div class="space-y-3">
          <div v-for="consult in latestConsultations" :key="consult.id" 
               class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex items-center">
              <span class="text-2xl mr-3">💬</span>
              <div>
                <p class="font-medium text-gray-900">{{ consult.userName }}</p>
                <p class="text-sm text-gray-600">{{ consult.title }}</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm text-gray-600">{{ consult.time }}</p>
              <span class="text-xs px-2 py-1"
                    :class="getStatusClass(consult.status)">
                {{ consult.status }}
              </span>
            </div>
          </div>
        </div>
        <div class="mt-4 text-center">
          <router-link to="/admin/consultations" 
                       class="text-sm text-primary hover:underline">
            查看全部諮詢 →
          </router-link>
        </div>
      </BaseCard>
    </div>
  </AdminLayout>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import AdminLayout from '../../components/AdminLayout.vue'
import BaseCard from '../../components/BaseCard.vue'
import { Chart, LineController, BarController, DoughnutController, CategoryScale, LinearScale, PointElement, LineElement, BarElement, ArcElement, Tooltip, Legend } from 'chart.js'

// Register Chart.js components
Chart.register(LineController, BarController, DoughnutController, CategoryScale, LinearScale, PointElement, LineElement, BarElement, ArcElement, Tooltip, Legend)

const trendChart = ref(null)
const pieChart = ref(null)
const ageChart = ref(null)
const genderChart = ref(null)

const stats = ref([
  { label: '今日測驗人數', value: '45', change: 12, icon: '📝', color: 'blue' },
  { label: '總測驗次數', value: '1,253', change: 8, icon: '✓', color: 'green' },
  { label: '待處理諮詢', value: '8', change: -15, icon: '💬', color: 'yellow' },
  { label: '註冊使用者', value: '856', change: 23, icon: '👥', color: 'purple' }
])

const latestTests = ref([
  { id: 1, userName: '王小明', testName: '大五人格測驗', time: '5分鐘前', icon: '🎭' },
  { id: 2, userName: '李小華', testName: '大五人格測驗', time: '15分鐘前', icon: '🎭' },
  { id: 3, userName: '張大同', testName: '大五人格測驗', time: '23分鐘前', icon: '🎭' },
  { id: 4, userName: '陳美玲', testName: '大五人格測驗', time: '45分鐘前', icon: '🎭' },
  { id: 5, userName: '林志明', testName: '大五人格測驗', time: '1小時前', icon: '🎭' }
])

const latestConsultations = ref([
  { id: 1, userName: '王小明', title: '關於測驗結果的疑問', time: '10分鐘前', status: '待處理' },
  { id: 2, userName: '李小華', title: '職業發展諮詢', time: '30分鐘前', status: '處理中' },
  { id: 3, userName: '張大同', title: '人際關係輔導', time: '2小時前', status: '待處理' },
  { id: 4, userName: '陳美玲', title: '測驗結果解讀', time: '5小時前', status: '已完成' }
])

function getStatColor(color) {
  const colors = {
    blue: 'text-blue-500',
    green: 'text-green-500',
    yellow: 'text-yellow-500',
    purple: 'text-purple-500'
  }
  return colors[color] || 'text-gray-500'
}

function getStatusClass(status) {
  const classes = {
    '待處理': 'bg-yellow-100 text-yellow-800 rounded-full',
    '處理中': 'bg-blue-100 text-blue-800 rounded-full',
    '已完成': 'bg-green-100 text-green-800 rounded-full'
  }
  return classes[status] || 'bg-gray-100 text-gray-800 rounded-full'
}

onMounted(() => {
  createTrendChart()
  createPieChart()
  createAgeChart()
  createGenderChart()
})

function createTrendChart() {
  if (!trendChart.value) return

  const ctx = trendChart.value.getContext('2d')
  new Chart(ctx, {
    type: 'line',
    data: {
      labels: ['D-30', 'D-25', 'D-20', 'D-15', 'D-10', 'D-5', '今天'],
      datasets: [{
        label: '測驗次數',
        data: [32, 45, 38, 52, 48, 55, 45],
        borderColor: 'rgb(44, 62, 80)',
        backgroundColor: 'rgba(44, 62, 80, 0.1)',
        tension: 0.4
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        }
      }
    }
  })
}

function createPieChart() {
  if (!pieChart.value) return

  const ctx = pieChart.value.getContext('2d')
  new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['大五人格', '16PF', 'MMPI', 'MBTI'],
      datasets: [{
        data: [85, 10, 3, 2],
        backgroundColor: [
          'rgb(44, 62, 80)',
          'rgb(52, 152, 219)',
          'rgb(231, 76, 60)',
          'rgb(149, 165, 166)'
        ]
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false
    }
  })
}

function createAgeChart() {
  if (!ageChart.value) return

  const ctx = ageChart.value.getContext('2d')
  new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['18-25', '26-35', '36-45', '46-55', '56+'],
      datasets: [{
        label: '人數',
        data: [220, 380, 185, 95, 45],
        backgroundColor: 'rgba(44, 62, 80, 0.8)'
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: {
          display: false
        }
      }
    }
  })
}

function createGenderChart() {
  if (!genderChart.value) return

  const ctx = genderChart.value.getContext('2d')
  new Chart(ctx, {
    type: 'doughnut',
    data: {
      labels: ['男性', '女性', '其他'],
      datasets: [{
        data: [42, 53, 5],
        backgroundColor: [
          'rgb(52, 152, 219)',
          'rgb(231, 76, 60)',
          'rgb(149, 165, 166)'
        ]
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false
    }
  })
}
</script>

