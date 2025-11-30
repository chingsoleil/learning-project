<template>
  <AdminLayout>
    <BaseCard>
      <h3 class="text-lg font-semibold mb-6">系統設定</h3>
      
      <div class="space-y-6">
        <div>
          <h4 class="font-medium text-gray-900 mb-3">一般設定</h4>
          <div class="space-y-4">
            <BaseInput id="site-name" v-model="siteSettings.name" label="網站名稱" />
            <BaseInput id="contact-email" v-model="siteSettings.email" type="email" label="聯絡Email" />
          </div>
        </div>

        <div class="border-t pt-6">
          <h4 class="font-medium text-gray-900 mb-3">測驗設定</h4>
          <div class="space-y-4">
            <div class="flex items-center justify-between">
              <span class="text-gray-700">啟用時間限制</span>
              <input type="checkbox" v-model="testSettings.enableTimeLimit" class="toggle" />
            </div>
            <BaseInput id="time-limit" v-model.number="testSettings.defaultTimeLimit" 
                      type="number" label="預設時間限制（分鐘）" />
          </div>
        </div>

        <div class="pt-6">
          <BaseButton>儲存設定</BaseButton>
        </div>
      </div>
    </BaseCard>
  </AdminLayout>
</template>

<script setup>
import { reactive } from 'vue'
import AdminLayout from '../../components/AdminLayout.vue'
import BaseCard from '../../components/BaseCard.vue'
import BaseInput from '../../components/BaseInput.vue'
import BaseButton from '../../components/BaseButton.vue'

const siteSettings = reactive({
  name: '心理測驗系統',
  email: 'info@psychtest.com'
})

const testSettings = reactive({
  enableTimeLimit: true,
  defaultTimeLimit: 30
})
</script>

