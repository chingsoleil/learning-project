<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <div class="flex items-center">
            <h1 class="text-2xl font-bold text-primary">心理測驗系統</h1>
          </div>
          <div class="hidden md:flex space-x-6">
            <RouterLink to="/" class="text-gray-700 hover:text-primary">首頁</RouterLink>
            <RouterLink to="/report/history" class="text-gray-700 hover:text-primary">查看報告</RouterLink>
          </div>
        </div>
      </div>
    </nav>

    <!-- Hero Section -->
    <section class="py-12 md:py-20 bg-gradient-to-br from-primary/5 to-secondary/5">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="text-center">
          <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
            探索你的人格特質
          </h2>
          <p class="text-lg md:text-xl text-gray-600 mb-8">
            透過科學化的心理測驗，深入了解自己
          </p>
          <BaseButton @click="goToTest" size="large">
            開始測驗
          </BaseButton>
        </div>
      </div>
    </section>

    <!-- Test Cards Section -->
    <section class="py-12 md:py-16">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h3 class="text-2xl md:text-3xl font-bold text-gray-900 mb-8 text-center">
          選擇測驗
        </h3>
        
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <!-- Big Five Test Card -->
          <BaseCard class="cursor-pointer" @click="goToTest">
            <div class="text-center">
              <div class="w-20 h-20 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl">🎭</span>
              </div>
              <h4 class="text-xl font-semibold text-gray-900 mb-2">大五人格測驗</h4>
              <p class="text-gray-600 mb-4">
                評估你在五大人格維度的表現
              </p>
              <div class="flex items-center justify-center text-sm text-gray-500 space-x-4">
                <span>📝 50題</span>
                <span>⏱️ 10-15分鐘</span>
              </div>
            </div>
          </BaseCard>

          <!-- Coming Soon Cards -->
          <BaseCard class="opacity-50">
            <div class="text-center">
              <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl">💼</span>
              </div>
              <h4 class="text-xl font-semibold text-gray-900 mb-2">職業興趣測驗</h4>
              <p class="text-gray-600 mb-4">
                探索最適合你的職業方向
              </p>
              <span class="inline-block bg-gray-200 text-gray-600 px-3 py-1 rounded-full text-sm">
                即將推出
              </span>
            </div>
          </BaseCard>

          <BaseCard class="opacity-50">
            <div class="text-center">
              <div class="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <span class="text-4xl">💡</span>
              </div>
              <h4 class="text-xl font-semibold text-gray-900 mb-2">情緒智商測驗</h4>
              <p class="text-gray-600 mb-4">
                了解你的情緒管理能力
              </p>
              <span class="inline-block bg-gray-200 text-gray-600 px-3 py-1 rounded-full text-sm">
                即將推出
              </span>
            </div>
          </BaseCard>
        </div>
      </div>
    </section>

    <!-- Features Section -->
    <section class="py-12 md:py-16 bg-white">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <h3 class="text-2xl md:text-3xl font-bold text-gray-900 mb-12 text-center">
          我們的特色
        </h3>
        
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div class="text-center">
            <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-3xl">✓</span>
            </div>
            <h4 class="text-lg font-semibold text-gray-900 mb-2">專業可靠</h4>
            <p class="text-gray-600">
              基於國際認可的心理學理論與研究
            </p>
          </div>
          
          <div class="text-center">
            <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-3xl">⚡</span>
            </div>
            <h4 class="text-lg font-semibold text-gray-900 mb-2">即時報告</h4>
            <p class="text-gray-600">
              完成測驗後立即獲得詳細分析報告
            </p>
          </div>
          
          <div class="text-center">
            <div class="w-16 h-16 bg-primary/10 rounded-full flex items-center justify-center mx-auto mb-4">
              <span class="text-3xl">🔒</span>
            </div>
            <h4 class="text-lg font-semibold text-gray-900 mb-2">隱私保護</h4>
            <p class="text-gray-600">
              所有資料加密儲存，嚴格保護您的隱私
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="bg-gray-900 text-white py-8">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
          <div>
            <h5 class="text-lg font-semibold mb-4">關於我們</h5>
            <p class="text-gray-400 text-sm">
              提供專業的心理測驗服務，幫助人們更了解自己
            </p>
          </div>
          <div>
            <h5 class="text-lg font-semibold mb-4">聯絡資訊</h5>
            <p class="text-gray-400 text-sm">Email: info@psychtest.com</p>
            <p class="text-gray-400 text-sm">Tel: (02) 1234-5678</p>
          </div>
          <div>
            <h5 class="text-lg font-semibold mb-4">法律資訊</h5>
            <a href="#" class="text-gray-400 text-sm block hover:text-white">隱私政策</a>
            <a href="#" class="text-gray-400 text-sm block hover:text-white">服務條款</a>
          </div>
        </div>
        <div class="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400 text-sm">
          © 2025 心理測驗系統. All rights reserved.
        </div>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import BaseButton from '../components/BaseButton.vue'
import BaseCard from '../components/BaseCard.vue'

const router = useRouter()

function goToTest() {
  router.push('/test/big-five-intro')
}
</script>

