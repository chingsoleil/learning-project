<template>
  <div class="min-h-screen bg-gradient-to-br from-primary/5 to-secondary/5 flex items-center justify-center px-4">
    <BaseCard class="w-full max-w-md">
      <div class="text-center mb-8">
        <div class="w-20 h-20 bg-primary rounded-full flex items-center justify-center mx-auto mb-4">
          <span class="text-4xl text-white">🔐</span>
        </div>
        <h1 class="text-2xl font-bold text-gray-900 mb-2">管理系統登入</h1>
        <p class="text-gray-600">心理測驗系統後台管理</p>
      </div>

      <form @submit.prevent="handleLogin" class="space-y-6">
        <BaseInput
          id="username"
          v-model="formData.username"
          label="帳號"
          placeholder="請輸入帳號"
          :required="true"
          :error="errors.username"
        />

        <div>
          <BaseInput
            id="password"
            v-model="formData.password"
            :type="showPassword ? 'text' : 'password'"
            label="密碼"
            placeholder="請輸入密碼"
            :required="true"
            :error="errors.password"
          />
          <div class="flex items-center mt-2">
            <input 
              id="show-password" 
              type="checkbox" 
              v-model="showPassword"
              class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary"
            />
            <label for="show-password" class="ml-2 text-sm text-gray-700">
              顯示密碼
            </label>
          </div>
        </div>

        <div class="flex items-center justify-between">
          <label class="flex items-center">
            <input 
              type="checkbox" 
              v-model="formData.rememberMe"
              class="w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary"
            />
            <span class="ml-2 text-sm text-gray-700">記住我</span>
          </label>
          <a href="#" class="text-sm text-primary hover:underline">
            忘記密碼？
          </a>
        </div>

        <BaseButton type="submit" class="w-full" :loading="isLoading">
          登入
        </BaseButton>
      </form>

      <!-- Demo Credentials -->
      <div class="mt-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
        <p class="text-sm font-semibold text-blue-900 mb-2">🔍 測試帳號</p>
        <p class="text-xs text-blue-800">帳號: admin</p>
        <p class="text-xs text-blue-800">密碼: admin123</p>
      </div>

      <div class="mt-6 text-center">
        <a href="/" class="text-sm text-gray-600 hover:text-primary">
          ← 返回前台首頁
        </a>
      </div>
    </BaseCard>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import BaseCard from '../../components/BaseCard.vue'
import BaseInput from '../../components/BaseInput.vue'
import BaseButton from '../../components/BaseButton.vue'

const router = useRouter()

const formData = reactive({
  username: '',
  password: '',
  rememberMe: false
})

const errors = reactive({
  username: '',
  password: ''
})

const showPassword = ref(false)
const isLoading = ref(false)

async function handleLogin() {
  // Reset errors
  Object.keys(errors).forEach(key => errors[key] = '')

  // Validate
  if (!formData.username) {
    errors.username = '請輸入帳號'
    return
  }

  if (!formData.password) {
    errors.password = '請輸入密碼'
    return
  }

  isLoading.value = true

  // Simulate API call
  await new Promise(resolve => setTimeout(resolve, 1000))

  // Check credentials (in real app, call backend API)
  if (formData.username === 'admin' && formData.password === 'admin123') {
    // Save token
    localStorage.setItem('adminToken', 'mock-token-' + Date.now())
    
    if (formData.rememberMe) {
      localStorage.setItem('adminRemember', 'true')
    }

    // Navigate to dashboard
    router.push('/admin/dashboard')
  } else {
    errors.username = '帳號或密碼錯誤'
    errors.password = '帳號或密碼錯誤'
  }

  isLoading.value = false
}
</script>

