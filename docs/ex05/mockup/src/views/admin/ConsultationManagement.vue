<template>
  <AdminLayout>
    <BaseCard>
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead>
            <tr class="border-b border-gray-200">
              <th class="text-left py-3 px-4">ID</th>
              <th class="text-left py-3 px-4">使用者</th>
              <th class="text-left py-3 px-4">類別</th>
              <th class="text-left py-3 px-4">標題</th>
              <th class="text-left py-3 px-4">狀態</th>
              <th class="text-left py-3 px-4">建立時間</th>
              <th class="text-right py-3 px-4">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="consult in consultations" :key="consult.id" class="border-b border-gray-100">
              <td class="py-4 px-4">{{ consult.id }}</td>
              <td class="py-4 px-4 font-medium">{{ consult.userName }}</td>
              <td class="py-4 px-4">{{ consult.category }}</td>
              <td class="py-4 px-4">{{ consult.title }}</td>
              <td class="py-4 px-4">
                <span class="px-2 py-1 text-xs rounded-full" :class="getStatusClass(consult.status)">
                  {{ consult.status }}
                </span>
              </td>
              <td class="py-4 px-4">{{ consult.createdAt }}</td>
              <td class="py-4 px-4 text-right space-x-2">
                <button class="text-sm text-primary hover:underline">查看</button>
                <button class="text-sm text-secondary hover:underline">回覆</button>
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

const consultations = ref([
  { id: 'C001', userName: '王小明', category: '測驗解讀', title: '關於測驗結果的疑問', status: '待處理', createdAt: '2023-12-01 12:00' },
  { id: 'C002', userName: '李小華', category: '職業諮詢', title: '職業發展諮詢', status: '處理中', createdAt: '2023-12-01 10:30' }
])

function getStatusClass(status) {
  const classes = {
    '待處理': 'bg-yellow-100 text-yellow-800',
    '處理中': 'bg-blue-100 text-blue-800',
    '已完成': 'bg-green-100 text-green-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}
</script>

