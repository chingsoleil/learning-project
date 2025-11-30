<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <button @click="goHome" class="text-gray-600 hover:text-primary">
            ← 返回首頁
          </button>
          <h1 class="text-xl font-bold text-primary">測驗記錄</h1>
          <div class="w-20"></div>
        </div>
      </div>
    </nav>

    <div class="max-w-4xl mx-auto px-4 py-8">
      <!-- Verification Form -->
      <BaseCard v-if="!isVerified" class="mb-6">
        <h2 class="text-2xl font-bold text-gray-900 mb-4">查詢測驗記錄</h2>
        <p class="text-gray-600 mb-6">請輸入您的聯絡資訊以查看歷史記錄</p>
        
        <form @submit.prevent="handleVerify" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              驗證方式
            </label>
            <div class="flex gap-4 mb-4">
              <label class="flex items-center">
                <input type="radio" v-model="verifyMethod" value="email" class="mr-2" />
                <span>Email</span>
              </label>
              <label class="flex items-center">
                <input type="radio" v-model="verifyMethod" value="phone" class="mr-2" />
                <span>電話號碼</span>
              </label>
            </div>
          </div>

          <BaseInput
            v-if="verifyMethod === 'email'"
            id="verify-email"
            v-model="verifyEmail"
            type="email"
            label="Email"
            placeholder="example@email.com"
            :required="true"
          />

          <BaseInput
            v-else
            id="verify-phone"
            v-model="verifyPhone"
            type="tel"
            label="電話號碼"
            placeholder="0912-345-678"
            :required="true"
          />

          <BaseButton type="submit" class="w-full" :loading="isVerifying">
            發送驗證碼
          </BaseButton>
        </form>
      </BaseCard>

      <!-- Verification Code (after sending) -->
      <BaseCard v-if="codeSent && !isVerified" class="mb-6">
        <h3 class="text-lg font-semibold text-gray-900 mb-4">輸入驗證碼</h3>
        <p class="text-sm text-gray-600 mb-4">
          我們已將驗證碼發送至 {{ verifyMethod === 'email' ? verifyEmail : verifyPhone }}
        </p>
        
        <form @submit.prevent="handleCodeVerify" class="space-y-4">
          <BaseInput
            id="verify-code"
            v-model="verifyCode"
            label="驗證碼"
            placeholder="請輸入6位數驗證碼"
            :required="true"
            maxlength="6"
          />

          <div class="flex gap-4">
            <BaseButton type="button" variant="secondary" @click="codeSent = false" class="flex-1">
              重新輸入
            </BaseButton>
            <BaseButton type="submit" class="flex-1" :loading="isVerifying">
              驗證
            </BaseButton>
          </div>
        </form>
      </BaseCard>

      <!-- Test History (after verified) -->
      <div v-if="isVerified">
        <!-- User Info Summary -->
        <BaseCard class="mb-6">
          <div class="flex items-center justify-between">
            <div>
              <h3 class="text-lg font-semibold text-gray-900">{{ userInfo.name }}</h3>
              <p class="text-sm text-gray-600">{{ userInfo.email }}</p>
            </div>
            <BaseButton variant="secondary" size="small" @click="handleLogout">
              登出
            </BaseButton>
          </div>
        </BaseCard>

        <!-- Test Records Title -->
        <div class="flex items-center justify-between mb-6">
          <h2 class="text-2xl font-bold text-gray-900">我的測驗記錄</h2>
          <span class="text-sm text-gray-600">共 {{ testRecords.length }} 筆記錄</span>
        </div>

        <!-- Test Records (Desktop: Table) -->
        <div class="hidden md:block">
          <BaseCard padding="compact">
            <div class="overflow-x-auto">
              <table class="w-full">
                <thead>
                  <tr class="border-b border-gray-200">
                    <th class="text-left py-3 px-4 text-sm font-semibold text-gray-700">測驗名稱</th>
                    <th class="text-left py-3 px-4 text-sm font-semibold text-gray-700">完成日期</th>
                    <th class="text-left py-3 px-4 text-sm font-semibold text-gray-700">測驗編號</th>
                    <th class="text-right py-3 px-4 text-sm font-semibold text-gray-700">操作</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="record in testRecords" :key="record.sessionId" 
                      class="border-b border-gray-100 hover:bg-gray-50">
                    <td class="py-4 px-4">
                      <div class="flex items-center">
                        <span class="text-2xl mr-3">🎭</span>
                        <span class="font-medium text-gray-900">{{ record.testName }}</span>
                      </div>
                    </td>
                    <td class="py-4 px-4 text-gray-600">{{ record.completedDate }}</td>
                    <td class="py-4 px-4 text-gray-600">Session #{{ record.sessionId }}</td>
                    <td class="py-4 px-4">
                      <div class="flex justify-end gap-2">
                        <button @click="viewReport(record.sessionId)" 
                                class="text-sm text-primary hover:underline">
                          查看報告
                        </button>
                        <button @click="downloadPDF(record.sessionId)" 
                                class="text-sm text-secondary hover:underline">
                          下載PDF
                        </button>
                        <button @click="deleteRecord(record.sessionId)" 
                                class="text-sm text-red-500 hover:underline">
                          刪除
                        </button>
                      </div>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </BaseCard>
        </div>

        <!-- Test Records (Mobile: Cards) -->
        <div class="md:hidden space-y-4">
          <BaseCard v-for="record in testRecords" :key="record.sessionId" padding="compact">
            <div class="flex items-start justify-between mb-3">
              <div class="flex items-center">
                <span class="text-3xl mr-3">🎭</span>
                <div>
                  <p class="font-semibold text-gray-900">{{ record.testName }}</p>
                  <p class="text-sm text-gray-600">{{ record.completedDate }}</p>
                  <p class="text-xs text-gray-500">Session #{{ record.sessionId }}</p>
                </div>
              </div>
            </div>
            <div class="flex gap-2">
              <BaseButton size="small" @click="viewReport(record.sessionId)" class="flex-1">
                查看
              </BaseButton>
              <BaseButton size="small" variant="secondary" @click="downloadPDF(record.sessionId)" class="flex-1">
                下載
              </BaseButton>
              <button @click="deleteRecord(record.sessionId)" 
                      class="px-3 py-2 text-sm text-red-500 hover:bg-red-50 rounded-lg">
                🗑️
              </button>
            </div>
          </BaseCard>
        </div>

        <!-- Empty State -->
        <BaseCard v-if="testRecords.length === 0" class="text-center py-12">
          <p class="text-6xl mb-4">📋</p>
          <h3 class="text-xl font-semibold text-gray-900 mb-2">尚無測驗記錄</h3>
          <p class="text-gray-600 mb-6">開始您的第一次測驗，探索自己的人格特質</p>
          <BaseButton @click="goHome">
            前往測驗
          </BaseButton>
        </BaseCard>

        <!-- Pagination -->
        <div v-if="testRecords.length > 10" class="flex justify-center mt-6">
          <div class="flex gap-2">
            <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
              上一頁
            </button>
            <button class="px-4 py-2 bg-primary text-white rounded-lg">
              1
            </button>
            <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
              2
            </button>
            <button class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50">
              下一頁
            </button>
          </div>
        </div>

        <!-- New Test Button (Fixed at bottom on mobile) -->
        <div class="fixed bottom-6 right-6 md:hidden">
          <button @click="goHome" 
                  class="w-14 h-14 bg-primary text-white rounded-full shadow-lg hover:bg-primary/90 flex items-center justify-center text-2xl">
            +
          </button>
        </div>

        <!-- New Test Button (Desktop) -->
        <div class="hidden md:block mt-6 text-center">
          <BaseButton @click="goHome" size="large">
            進行新測驗
          </BaseButton>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import BaseCard from '../components/BaseCard.vue'
import BaseInput from '../components/BaseInput.vue'
import BaseButton from '../components/BaseButton.vue'

const router = useRouter()

const isVerified = ref(false)
const isVerifying = ref(false)
const codeSent = ref(false)
const verifyMethod = ref('email')
const verifyEmail = ref('')
const verifyPhone = ref('')
const verifyCode = ref('')

const userInfo = reactive({
  name: '王小明',
  email: 'example@email.com'
})

const testRecords = ref([
  {
    sessionId: 1701234567890,
    testName: '大五人格測驗',
    completedDate: '2023-12-01 11:15',
    scores: {
      openness: 75,
      conscientiousness: 85,
      extraversion: 70,
      agreeableness: 80,
      neuroticism: 45
    }
  },
  {
    sessionId: 1698642367890,
    testName: '大五人格測驗',
    completedDate: '2023-10-15 14:30',
    scores: {
      openness: 72,
      conscientiousness: 83,
      extraversion: 68,
      agreeableness: 78,
      neuroticism: 48
    }
  },
  {
    sessionId: 1696050167890,
    testName: '大五人格測驗',
    completedDate: '2023-09-20 09:45',
    scores: {
      openness: 70,
      conscientiousness: 80,
      extraversion: 65,
      agreeableness: 75,
      neuroticism: 50
    }
  }
])

async function handleVerify() {
  isVerifying.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  codeSent.value = true
  isVerifying.value = false
}

async function handleCodeVerify() {
  if (verifyCode.value.length !== 6) {
    alert('請輸入6位數驗證碼')
    return
  }

  isVerifying.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  
  // In real app, verify code with backend
  if (verifyCode.value === '123456' || verifyCode.value.length === 6) {
    isVerified.value = true
  } else {
    alert('驗證碼錯誤，請重新輸入')
  }
  
  isVerifying.value = false
}

function viewReport(sessionId) {
  router.push(`/report/detail/${sessionId}`)
}

function downloadPDF(sessionId) {
  alert(`下載 Session #${sessionId} 的 PDF 報告\n（此功能將在實際開發時實作）`)
}

function deleteRecord(sessionId) {
  if (confirm('確定要刪除這筆測驗記錄嗎？此操作無法復原。')) {
    testRecords.value = testRecords.value.filter(r => r.sessionId !== sessionId)
    alert('記錄已刪除')
  }
}

function handleLogout() {
  if (confirm('確定要登出嗎？')) {
    isVerified.value = false
    codeSent.value = false
    verifyEmail.value = ''
    verifyPhone.value = ''
    verifyCode.value = ''
  }
}

function goHome() {
  router.push('/')
}
</script>

