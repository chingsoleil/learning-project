<template>
  <AdminLayout>
    <div class="mb-6">
      <BaseButton @click="showNewTestModal = true">
        + 新增測驗
      </BaseButton>
    </div>

    <BaseCard>
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead>
            <tr class="border-b border-gray-200">
              <th class="text-left py-3 px-4">測驗ID</th>
              <th class="text-left py-3 px-4">測驗名稱</th>
              <th class="text-left py-3 px-4">題數</th>
              <th class="text-left py-3 px-4">狀態</th>
              <th class="text-left py-3 px-4">完成次數</th>
              <th class="text-right py-3 px-4">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="test in tests" :key="test.id" class="border-b border-gray-100">
              <td class="py-4 px-4">{{ test.code }}</td>
              <td class="py-4 px-4 font-medium">{{ test.name }}</td>
              <td class="py-4 px-4">{{ test.questionCount }}</td>
              <td class="py-4 px-4">
                <span class="px-2 py-1 text-xs rounded-full"
                      :class="test.isActive ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'">
                  {{ test.isActive ? '啟用' : '停用' }}
                </span>
              </td>
              <td class="py-4 px-4">{{ test.completedCount }}</td>
              <td class="py-4 px-4 text-right space-x-2">
                <button class="text-sm text-primary hover:underline">編輯</button>
                <button class="text-sm text-secondary hover:underline">預覽</button>
                <button class="text-sm text-red-500 hover:underline">刪除</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </BaseCard>
  </AdminLayout>
</template>

<script setup>
import { ref } from 'vue'
import AdminLayout from '../../components/AdminLayout.vue'
import BaseCard from '../../components/BaseCard.vue'
import BaseButton from '../../components/BaseButton.vue'

const showNewTestModal = ref(false)
const tests = ref([
  { id: 1, code: 'BF001', name: '大五人格測驗', questionCount: 50, isActive: true, completedCount: 1253 },
  { id: 2, code: '16PF001', name: '16PF人格測驗', questionCount: 60, isActive: false, completedCount: 0 }
])
</script>

