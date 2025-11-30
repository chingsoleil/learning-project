<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <h1 class="text-xl font-bold text-primary">測驗結果</h1>
        </div>
      </div>
    </nav>

    <div class="max-w-6xl mx-auto px-4 py-8">
      <!-- Success Animation -->
      <div class="text-center mb-8 animate-fade-in">
        <div class="inline-block w-20 h-20 bg-green-500 rounded-full flex items-center justify-center mb-4">
          <span class="text-4xl text-white">✓</span>
        </div>
        <h2 class="text-3xl font-bold text-gray-900 mb-2">測驗完成！</h2>
        <p class="text-gray-600">感謝您完成大五人格測驗</p>
      </div>

      <!-- Test Info -->
      <BaseCard class="mb-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-center">
          <div>
            <p class="text-sm text-gray-500 mb-1">測驗名稱</p>
            <p class="text-lg font-semibold text-gray-900">大五人格測驗</p>
          </div>
          <div>
            <p class="text-sm text-gray-500 mb-1">完成時間</p>
            <p class="text-lg font-semibold text-gray-900">{{ completedTime }}</p>
          </div>
          <div>
            <p class="text-sm text-gray-500 mb-1">測驗編號</p>
            <p class="text-lg font-semibold text-gray-900">Session #{{ sessionId }}</p>
          </div>
        </div>
      </BaseCard>

      <!-- User Info -->
      <BaseCard class="mb-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">受測者資訊</h3>
        <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div>
            <p class="text-sm text-gray-500">姓名</p>
            <p class="text-base font-medium text-gray-900">{{ userInfo.testTakerName }}</p>
          </div>
          <div>
            <p class="text-sm text-gray-500">性別</p>
            <p class="text-base font-medium text-gray-900">{{ getGenderLabel(userInfo.gender) }}</p>
          </div>
          <div>
            <p class="text-sm text-gray-500">年齡</p>
            <p class="text-base font-medium text-gray-900">{{ userInfo.age }} 歲</p>
          </div>
        </div>
      </BaseCard>

      <!-- Radar Chart -->
      <BaseCard class="mb-6">
        <h3 class="text-xl font-semibold text-gray-900 mb-6 text-center">人格特質分析</h3>
        <div class="max-w-md mx-auto">
          <canvas ref="radarChart"></canvas>
        </div>
      </BaseCard>

      <!-- Dimension Scores -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
        <BaseCard v-for="dimension in dimensions" :key="dimension.id" padding="normal">
          <div class="flex items-start">
            <span class="text-4xl mr-4">{{ dimension.icon }}</span>
            <div class="flex-1">
              <h4 class="text-lg font-semibold text-gray-900 mb-2">{{ dimension.nameZh }}</h4>
              <div class="mb-2">
                <div class="flex justify-between text-sm mb-1">
                  <span class="text-gray-600">分數</span>
                  <span class="font-semibold text-gray-900">{{ dimension.score.rawScore }} / 50</span>
                </div>
                <div class="w-full bg-gray-200 rounded-full h-2">
                  <div class="bg-primary h-2 rounded-full transition-all" 
                       :style="{ width: (dimension.score.rawScore / 50 * 100) + '%' }"></div>
                </div>
              </div>
              <div class="flex items-center justify-between mb-2">
                <span class="text-sm text-gray-600">百分位</span>
                <span class="text-sm font-semibold text-secondary">
                  {{ dimension.score.percentile }}% (高於 {{ dimension.score.percentile }}% 的人)
                </span>
              </div>
              <div class="flex items-center mb-3">
                <span class="text-sm text-gray-600 mr-2">評級</span>
                <div class="flex">
                  <span v-for="i in 5" :key="i" 
                        :class="i <= getStarCount(dimension.score.percentile) ? 'text-yellow-400' : 'text-gray-300'"
                        class="text-lg">★</span>
                </div>
                <span class="ml-2 text-sm font-medium" :class="getLevelColor(dimension.score.level)">
                  {{ dimension.score.level }}
                </span>
              </div>
              <p class="text-sm text-gray-600">{{ dimension.description }}</p>
            </div>
          </div>
        </BaseCard>
      </div>

      <!-- Summary -->
      <BaseCard class="mb-8">
        <h3 class="text-xl font-semibold text-gray-900 mb-4">整體分析摘要</h3>
        <p class="text-gray-700 leading-relaxed">
          根據您的測驗結果，您展現出高度的<strong>嚴謹性</strong>和<strong>親和性</strong>，
          這表示您是一個有組織、可靠且善於與他人合作的人。您的<strong>經驗開放性</strong>也相當不錯，
          顯示您願意接受新的想法和體驗。在<strong>外向性</strong>方面，您處於中等水平，
          表示您能夠在社交和獨處之間取得良好平衡。您的<strong>神經質</strong>分數較低，
          代表您的情緒相對穩定，能夠有效處理壓力和挑戰。
        </p>
        <p class="text-gray-700 leading-relaxed mt-4">
          這樣的人格組合通常在需要團隊合作、組織規劃的工作環境中表現出色。
          您可能適合從事需要與人互動、同時也需要嚴謹執行的職業，例如專案管理、人力資源、教育或諮詢等領域。
        </p>
      </BaseCard>

      <!-- Action Buttons -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <BaseButton @click="viewDetailedReport" class="w-full">
          📊 查看完整報告
        </BaseButton>
        <BaseButton variant="secondary" @click="downloadPDF" class="w-full">
          📥 下載 PDF
        </BaseButton>
        <BaseButton variant="secondary" @click="shareResult" class="w-full">
          🔗 分享結果
        </BaseButton>
        <BaseButton variant="ghost" @click="retakeTest" class="w-full">
          🔄 重新測驗
        </BaseButton>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useTestStore } from '../stores/test'
import BaseCard from '../components/BaseCard.vue'
import BaseButton from '../components/BaseButton.vue'
import { Chart, RadarController, RadialLinearScale, PointElement, LineElement, Filler, Tooltip, Legend } from 'chart.js'

// Register Chart.js components
Chart.register(RadarController, RadialLinearScale, PointElement, LineElement, Filler, Tooltip, Legend)

const route = useRoute()
const router = useRouter()
const testStore = useTestStore()

const radarChart = ref(null)
const sessionId = ref(route.params.sessionId)

const userInfo = computed(() => testStore.userInfo || {})

const completedTime = computed(() => {
  return new Date().toLocaleString('zh-TW', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
})

// Mock scores (in real app, calculate from answers)
const dimensions = ref([
  {
    id: 'openness',
    nameZh: '經驗開放性',
    icon: '🎨',
    description: '您對新體驗持開放態度，富有想像力與創造力。',
    score: { rawScore: 38, maxScore: 50, percentile: 75, level: '高' }
  },
  {
    id: 'conscientiousness',
    nameZh: '嚴謹性',
    icon: '📋',
    description: '您是一個有組織且可靠的人，能夠有效管理時間與責任。',
    score: { rawScore: 42, maxScore: 50, percentile: 85, level: '高' }
  },
  {
    id: 'extraversion',
    nameZh: '外向性',
    icon: '🎉',
    description: '您在社交場合表現得體，能夠平衡獨處與社交的需求。',
    score: { rawScore: 35, maxScore: 50, percentile: 70, level: '中高' }
  },
  {
    id: 'agreeableness',
    nameZh: '親和性',
    icon: '🤝',
    description: '您善於合作且富有同理心，容易與他人建立良好關係。',
    score: { rawScore: 40, maxScore: 50, percentile: 80, level: '高' }
  },
  {
    id: 'neuroticism',
    nameZh: '神經質',
    icon: '😰',
    description: '您的情緒相對穩定，能夠適當處理壓力與挑戰。',
    score: { rawScore: 25, maxScore: 50, percentile: 45, level: '中' }
  }
])

onMounted(() => {
  createRadarChart()
})

function createRadarChart() {
  if (!radarChart.value) return

  const ctx = radarChart.value.getContext('2d')
  
  new Chart(ctx, {
    type: 'radar',
    data: {
      labels: dimensions.value.map(d => d.nameZh),
      datasets: [{
        label: '您的分數',
        data: dimensions.value.map(d => d.score.percentile),
        backgroundColor: 'rgba(44, 62, 80, 0.2)',
        borderColor: 'rgba(44, 62, 80, 1)',
        borderWidth: 2,
        pointBackgroundColor: 'rgba(44, 62, 80, 1)',
        pointBorderColor: '#fff',
        pointHoverBackgroundColor: '#fff',
        pointHoverBorderColor: 'rgba(44, 62, 80, 1)'
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      scales: {
        r: {
          beginAtZero: true,
          max: 100,
          ticks: {
            stepSize: 20
          }
        }
      },
      plugins: {
        legend: {
          display: false
        },
        tooltip: {
          callbacks: {
            label: function(context) {
              return context.label + ': ' + context.parsed.r + '%'
            }
          }
        }
      }
    }
  })
}

function getGenderLabel(gender) {
  const labels = {
    'Male': '男性',
    'Female': '女性',
    'Other': '其他',
    'PreferNotToSay': '不願透露'
  }
  return labels[gender] || gender
}

function getStarCount(percentile) {
  if (percentile >= 90) return 5
  if (percentile >= 75) return 4
  if (percentile >= 50) return 3
  if (percentile >= 25) return 2
  return 1
}

function getLevelColor(level) {
  const colors = {
    '很高': 'text-green-600',
    '高': 'text-green-600',
    '中高': 'text-blue-600',
    '中': 'text-gray-600',
    '中低': 'text-orange-600',
    '低': 'text-red-600'
  }
  return colors[level] || 'text-gray-600'
}

function viewDetailedReport() {
  router.push(`/report/detail/${sessionId.value}`)
}

function downloadPDF() {
  alert('PDF 下載功能將在實際開發時實作')
}

function shareResult() {
  const url = window.location.href
  if (navigator.share) {
    navigator.share({
      title: '我的大五人格測驗結果',
      text: '我剛完成了大五人格測驗，快來看看我的結果！',
      url: url
    })
  } else {
    navigator.clipboard.writeText(url)
    alert('連結已複製到剪貼簿！')
  }
}

function retakeTest() {
  if (confirm('確定要重新測驗嗎？目前的結果將會保留。')) {
    testStore.reset()
    router.push('/test/big-five-intro')
  }
}
</script>

<style scoped>
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fadeIn 0.6s ease-out;
}
</style>

