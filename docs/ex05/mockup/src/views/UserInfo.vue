<template>
  <div class="min-h-screen bg-gray-50 pb-20">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <button @click="goBack" class="text-gray-600 hover:text-primary">
            ← 返回
          </button>
        </div>
      </div>
    </nav>

    <!-- Progress Indicator -->
    <div class="max-w-2xl mx-auto px-4 py-6">
      <div class="flex items-center justify-between mb-2">
        <span class="text-sm font-medium text-primary">1. 個人資訊</span>
        <span class="text-sm text-gray-400">2. 答題</span>
        <span class="text-sm text-gray-400">3. 結果</span>
      </div>
      <div class="w-full bg-gray-200 rounded-full h-2">
        <div class="bg-primary h-2 rounded-full" style="width: 33.33%"></div>
      </div>
    </div>

    <!-- Form -->
    <div class="max-w-2xl mx-auto px-4 py-8">
      <BaseCard>
        <h2 class="text-2xl font-bold text-gray-900 mb-6">請填寫基本資料</h2>
        
        <form @submit.prevent="handleSubmit" class="space-y-6">
          <BaseInput
            id="name"
            v-model="formData.name"
            label="姓名"
            placeholder="請輸入您的姓名"
            :required="true"
            :error="errors.name"
          />

          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">
              性別 <span class="text-red-500">*</span>
            </label>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
              <label v-for="option in genderOptions" :key="option.value"
                     class="flex items-center justify-center p-3 border-2 rounded-lg cursor-pointer transition-all"
                     :class="formData.gender === option.value 
                       ? 'border-primary bg-primary/5' 
                       : 'border-gray-200 hover:border-primary/50'">
                <input 
                  type="radio" 
                  v-model="formData.gender" 
                  :value="option.value"
                  class="sr-only"
                />
                <span class="text-2xl mr-2">{{ option.icon }}</span>
                <span class="text-sm font-medium">{{ option.label }}</span>
              </label>
            </div>
            <p v-if="errors.gender" class="mt-1 text-sm text-red-500">{{ errors.gender }}</p>
          </div>

          <BaseInput
            id="age"
            v-model.number="formData.age"
            type="number"
            label="年齡"
            placeholder="請輸入您的年齡"
            :required="true"
            :error="errors.age"
            hint="必須年滿18歲"
          />

          <BaseInput
            id="phone"
            v-model="formData.phone"
            type="tel"
            label="電話號碼"
            placeholder="0912-345-678"
            :required="true"
            :error="errors.phone"
            hint="格式：09XX-XXX-XXX"
          />

          <BaseInput
            id="email"
            v-model="formData.email"
            type="email"
            label="Email"
            placeholder="example@email.com"
            :required="true"
            :error="errors.email"
          />

          <div class="flex items-start">
            <input 
              id="terms" 
              type="checkbox" 
              v-model="formData.agreedToTerms"
              class="mt-1 w-4 h-4 text-primary border-gray-300 rounded focus:ring-primary"
            />
            <label for="terms" class="ml-2 text-sm text-gray-700">
              我已閱讀並同意
              <a href="#" class="text-primary hover:underline">隱私政策</a>
              與
              <a href="#" class="text-primary hover:underline">使用條款</a>
              <span class="text-red-500">*</span>
            </label>
          </div>
          <p v-if="errors.agreedToTerms" class="text-sm text-red-500">{{ errors.agreedToTerms }}</p>

          <div class="flex flex-col md:flex-row gap-4 pt-4">
            <BaseButton 
              type="button"
              variant="secondary"
              @click="goBack"
              class="flex-1"
            >
              返回
            </BaseButton>
            <BaseButton 
              type="submit"
              class="flex-1"
              :loading="isSubmitting"
            >
              下一步 →
            </BaseButton>
          </div>
        </form>
      </BaseCard>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useTestStore } from '../stores/test'
import BaseCard from '../components/BaseCard.vue'
import BaseInput from '../components/BaseInput.vue'
import BaseButton from '../components/BaseButton.vue'

const router = useRouter()
const testStore = useTestStore()

const formData = reactive({
  name: '',
  gender: '',
  age: '',
  phone: '',
  email: '',
  agreedToTerms: false
})

const errors = reactive({
  name: '',
  gender: '',
  age: '',
  phone: '',
  email: '',
  agreedToTerms: ''
})

const isSubmitting = ref(false)

const genderOptions = [
  { value: 'Male', label: '男性', icon: '👨' },
  { value: 'Female', label: '女性', icon: '👩' },
  { value: 'Other', label: '其他', icon: '🧑' },
  { value: 'PreferNotToSay', label: '不願透露', icon: '❓' }
]

function validateForm() {
  let isValid = true
  
  // Reset errors
  Object.keys(errors).forEach(key => errors[key] = '')
  
  // Validate name
  if (!formData.name.trim()) {
    errors.name = '請輸入姓名'
    isValid = false
  }
  
  // Validate gender
  if (!formData.gender) {
    errors.gender = '請選擇性別'
    isValid = false
  }
  
  // Validate age
  if (!formData.age) {
    errors.age = '請輸入年齡'
    isValid = false
  } else if (formData.age < 18 || formData.age > 100) {
    errors.age = '年齡必須在 18-100 之間'
    isValid = false
  }
  
  // Validate phone
  const phoneRegex = /^09\d{2}-?\d{3}-?\d{3}$/
  if (!formData.phone) {
    errors.phone = '請輸入電話號碼'
    isValid = false
  } else if (!phoneRegex.test(formData.phone.replace(/-/g, ''))) {
    errors.phone = '電話號碼格式不正確'
    isValid = false
  }
  
  // Validate email
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
  if (!formData.email) {
    errors.email = '請輸入 Email'
    isValid = false
  } else if (!emailRegex.test(formData.email)) {
    errors.email = 'Email 格式不正確'
    isValid = false
  }
  
  // Validate terms
  if (!formData.agreedToTerms) {
    errors.agreedToTerms = '請同意隱私政策與使用條款'
    isValid = false
  }
  
  return isValid
}

async function handleSubmit() {
  if (!validateForm()) {
    return
  }
  
  isSubmitting.value = true
  
  // Simulate API call
  await new Promise(resolve => setTimeout(resolve, 500))
  
  // Save to store
  testStore.setUserInfo({
    testTakerName: formData.name,
    gender: formData.gender,
    age: formData.age,
    phone: formData.phone,
    email: formData.email
  })
  
  isSubmitting.value = false
  
  // Navigate to questions page
  router.push('/test/big-five/questions')
}

function goBack() {
  if (confirm('確定要返回嗎？已填寫的資料將不會儲存。')) {
    router.push('/test/big-five-intro')
  }
}
</script>

