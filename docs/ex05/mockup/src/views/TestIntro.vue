<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <div class="flex items-center space-x-4">
            <button @click="goBack" class="text-gray-600 hover:text-primary">
              ← 返回
            </button>
            <span class="text-sm text-gray-500">首頁 > 大五人格測驗</span>
          </div>
        </div>
      </div>
    </nav>

    <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <!-- Test Title -->
      <div class="text-center mb-8">
        <h1 class="text-3xl md:text-4xl font-bold text-gray-900 mb-4">
          大五人格測驗
        </h1>
        <p class="text-lg text-gray-600">
          Big Five Personality Test
        </p>
      </div>

      <!-- Test Introduction -->
      <BaseCard class="mb-6">
        <h2 class="text-2xl font-semibold text-gray-900 mb-4">測驗簡介</h2>
        <p class="text-gray-700 leading-relaxed mb-4">
          大五人格測驗是目前心理學界最廣泛使用的人格評估工具之一。它將人格特質分為五個主要維度，
          每個維度代表一組相關的人格特徵。透過這個測驗，您可以更深入地了解自己的性格特點、
          行為傾向以及與他人互動的方式。
        </p>
        <p class="text-gray-700 leading-relaxed">
          這個測驗基於數十年的心理學研究，具有高度的信度和效度。測驗結果可以幫助您在職業選擇、
          人際關係和個人成長等方面做出更明智的決策。
        </p>
      </BaseCard>

      <!-- Five Dimensions -->
      <BaseCard class="mb-6">
        <h2 class="text-2xl font-semibold text-gray-900 mb-6">五大人格維度</h2>
        <div class="space-y-4">
          <div v-for="dimension in dimensions" :key="dimension.id" 
               class="p-4 bg-gray-50 rounded-lg">
            <div class="flex items-start">
              <span class="text-3xl mr-4">{{ dimension.icon }}</span>
              <div>
                <h3 class="text-lg font-semibold text-gray-900 mb-1">
                  {{ dimension.nameZh }} ({{ dimension.nameEn }})
                </h3>
                <p class="text-gray-600 text-sm">
                  {{ dimension.description }}
                </p>
              </div>
            </div>
          </div>
        </div>
      </BaseCard>

      <!-- Test Info -->
      <BaseCard class="mb-6">
        <h2 class="text-2xl font-semibold text-gray-900 mb-4">測驗資訊</h2>
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div class="text-center p-4 bg-primary/5 rounded-lg">
            <p class="text-3xl font-bold text-primary mb-2">50</p>
            <p class="text-gray-600 text-sm">題目數量</p>
          </div>
          <div class="text-center p-4 bg-secondary/5 rounded-lg">
            <p class="text-3xl font-bold text-secondary mb-2">10-15</p>
            <p class="text-gray-600 text-sm">預估時間（分鐘）</p>
          </div>
          <div class="text-center p-4 bg-success/5 rounded-lg">
            <p class="text-3xl font-bold text-success mb-2">18+</p>
            <p class="text-gray-600 text-sm">適用年齡</p>
          </div>
        </div>
      </BaseCard>

      <!-- Important Notes -->
      <BaseCard class="mb-8">
        <h2 class="text-2xl font-semibold text-gray-900 mb-4">注意事項</h2>
        <ul class="space-y-2 text-gray-700">
          <li class="flex items-start">
            <span class="text-primary mr-2">•</span>
            <span>請在安靜、不受打擾的環境下作答</span>
          </li>
          <li class="flex items-start">
            <span class="text-primary mr-2">•</span>
            <span>依照直覺回答，不要想太久，測驗沒有對錯之分</span>
          </li>
          <li class="flex items-start">
            <span class="text-primary mr-2">•</span>
            <span>請誠實作答，這樣才能獲得最準確的結果</span>
          </li>
          <li class="flex items-start">
            <span class="text-primary mr-2">•</span>
            <span>所有資料都會加密儲存，嚴格保護您的隱私</span>
          </li>
          <li class="flex items-start">
            <span class="text-primary mr-2">•</span>
            <span>建議一次完成測驗，中途離開可能會遺失進度</span>
          </li>
        </ul>
      </BaseCard>

      <!-- Start Button -->
      <div class="text-center">
        <BaseButton @click="startTest" size="large" class="w-full md:w-auto">
          開始測驗 →
        </BaseButton>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import BaseCard from '../components/BaseCard.vue'
import BaseButton from '../components/BaseButton.vue'

const router = useRouter()

const dimensions = [
  {
    id: 'openness',
    nameEn: 'Openness',
    nameZh: '經驗開放性',
    description: '想像力、好奇心、創造力，願意嘗試新事物的程度',
    icon: '🎨'
  },
  {
    id: 'conscientiousness',
    nameEn: 'Conscientiousness',
    nameZh: '嚴謹性',
    description: '組織性、責任感、自律，做事認真謹慎的程度',
    icon: '📋'
  },
  {
    id: 'extraversion',
    nameEn: 'Extraversion',
    nameZh: '外向性',
    description: '社交性、活力、積極情緒，與他人互動的頻率與深度',
    icon: '🎉'
  },
  {
    id: 'agreeableness',
    nameEn: 'Agreeableness',
    nameZh: '親和性',
    description: '信任、利他、合作，對他人友善與同理心的程度',
    icon: '🤝'
  },
  {
    id: 'neuroticism',
    nameEn: 'Neuroticism',
    nameZh: '神經質',
    description: '焦慮、情緒不穩定、壓力反應，情緒調節的能力',
    icon: '😰'
  }
]

function goBack() {
  router.push('/')
}

function startTest() {
  router.push('/test/big-five/user-info')
}
</script>

