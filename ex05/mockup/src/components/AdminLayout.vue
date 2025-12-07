<template>
  <div class="flex h-screen bg-gray-50">
    <!-- Sidebar (Desktop) -->
    <aside class="hidden md:flex md:flex-col md:w-64 bg-white border-r border-gray-200">
      <div class="p-6 border-b border-gray-200">
        <h1 class="text-2xl font-bold text-primary">管理系統</h1>
        <p class="text-sm text-gray-600 mt-1">心理測驗後台</p>
      </div>
      
      <nav class="flex-1 p-4 overflow-y-auto">
        <div class="space-y-1">
          <RouterLink
            v-for="item in menuItems"
            :key="item.path"
            :to="item.path"
            class="flex items-center px-4 py-3 rounded-lg transition-colors"
            :class="isActive(item.path) 
              ? 'bg-primary text-white' 
              : 'text-gray-700 hover:bg-gray-100'"
          >
            <span class="text-xl mr-3">{{ item.icon }}</span>
            <span class="font-medium">{{ item.label }}</span>
          </RouterLink>
        </div>
      </nav>

      <div class="p-4 border-t border-gray-200">
        <div class="flex items-center mb-3">
          <div class="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white mr-3">
            👤
          </div>
          <div class="flex-1">
            <p class="text-sm font-semibold text-gray-900">Admin</p>
            <p class="text-xs text-gray-600">管理員</p>
          </div>
        </div>
        <button @click="handleLogout" 
                class="w-full px-4 py-2 text-sm text-red-600 hover:bg-red-50 rounded-lg transition-colors">
          登出
        </button>
      </div>
    </aside>

    <!-- Mobile Header -->
    <div class="md:hidden fixed top-0 left-0 right-0 bg-white border-b border-gray-200 z-10">
      <div class="flex items-center justify-between p-4">
        <button @click="toggleMobileMenu" class="text-2xl">
          {{ showMobileMenu ? '✕' : '☰' }}
        </button>
        <h1 class="text-lg font-bold text-primary">管理系統</h1>
        <div class="w-8"></div>
      </div>
    </div>

    <!-- Mobile Menu -->
    <Transition name="slide">
      <div v-if="showMobileMenu" 
           class="md:hidden fixed inset-0 z-20 bg-white"
           :class="{ 'pt-16': true }">
        <nav class="p-4 overflow-y-auto h-full pb-32">
          <div class="space-y-1">
            <RouterLink
              v-for="item in menuItems"
              :key="item.path"
              :to="item.path"
              @click="showMobileMenu = false"
              class="flex items-center px-4 py-3 rounded-lg transition-colors"
              :class="isActive(item.path) 
                ? 'bg-primary text-white' 
                : 'text-gray-700 hover:bg-gray-100'"
            >
              <span class="text-xl mr-3">{{ item.icon }}</span>
              <span class="font-medium">{{ item.label }}</span>
            </RouterLink>
          </div>
        </nav>

        <div class="fixed bottom-0 left-0 right-0 p-4 bg-white border-t border-gray-200">
          <button @click="handleLogout" 
                  class="w-full px-4 py-3 text-red-600 hover:bg-red-50 rounded-lg transition-colors">
            登出
          </button>
        </div>
      </div>
    </Transition>

    <!-- Main Content -->
    <div class="flex-1 flex flex-col overflow-hidden">
      <!-- Top Bar -->
      <header class="bg-white border-b border-gray-200 px-6 py-4 hidden md:block">
        <div class="flex items-center justify-between">
          <h2 class="text-2xl font-bold text-gray-900">{{ currentPageTitle }}</h2>
          <div class="flex items-center space-x-4">
            <span class="text-sm text-gray-600">{{ currentTime }}</span>
          </div>
        </div>
      </header>

      <!-- Page Content -->
      <main class="flex-1 overflow-y-auto p-4 md:p-6 mt-16 md:mt-0">
        <slot />
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter, RouterLink } from 'vue-router'

const route = useRoute()
const router = useRouter()

const showMobileMenu = ref(false)
const currentTime = ref(new Date().toLocaleString('zh-TW'))

const menuItems = ref([
  { path: '/admin/dashboard', icon: '📊', label: '儀表板' },
  { path: '/admin/tests', icon: '📝', label: '測驗管理' },
  { path: '/admin/users', icon: '👥', label: '使用者管理' },
  { path: '/admin/consultations', icon: '💬', label: '諮詢管理' },
  { path: '/admin/reports', icon: '📄', label: '報告管理' },
  { path: '/admin/settings', icon: '⚙️', label: '系統設定' }
])

const currentPageTitle = computed(() => {
  const item = menuItems.value.find(m => m.path === route.path)
  return item?.label || '管理系統'
})

function isActive(path) {
  return route.path === path || route.path.startsWith(path + '/')
}

function toggleMobileMenu() {
  showMobileMenu.value = !showMobileMenu.value
}

function handleLogout() {
  if (confirm('確定要登出嗎？')) {
    localStorage.removeItem('adminToken')
    localStorage.removeItem('adminRemember')
    router.push('/admin/login')
  }
}

let timeInterval
onMounted(() => {
  timeInterval = setInterval(() => {
    currentTime.value = new Date().toLocaleString('zh-TW')
  }, 1000)
})

onUnmounted(() => {
  clearInterval(timeInterval)
})
</script>

<style scoped>
.slide-enter-active,
.slide-leave-active {
  transition: transform 0.3s ease;
}

.slide-enter-from,
.slide-leave-to {
  transform: translateX(-100%);
}
</style>

