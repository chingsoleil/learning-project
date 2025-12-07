<template>
  <AdminLayout>
    <BaseCard>
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead>
            <tr class="border-b border-gray-200">
              <th class="text-left py-3 px-4">ID</th>
              <th class="text-left py-3 px-4">姓名</th>
              <th class="text-left py-3 px-4">Email</th>
              <th class="text-left py-3 px-4">測驗次數</th>
              <th class="text-left py-3 px-4">註冊日期</th>
              <th class="text-right py-3 px-4">操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="user in users" :key="user.id" class="border-b border-gray-100">
              <td class="py-4 px-4">{{ user.id }}</td>
              <td class="py-4 px-4 font-medium">{{ user.name }}</td>
              <td class="py-4 px-4">{{ user.email }}</td>
              <td class="py-4 px-4">{{ user.testCount }}</td>
              <td class="py-4 px-4">{{ user.createdAt }}</td>
              <td class="py-4 px-4 text-right space-x-2">
                <button class="text-sm text-primary hover:underline">查看</button>
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

const users = ref([
  { id: 'U001', name: '王小明', email: 'wang@example.com', testCount: 3, createdAt: '2023-11-01' },
  { id: 'U002', name: '李小華', email: 'lee@example.com', testCount: 2, createdAt: '2023-11-15' }
])
</script>

