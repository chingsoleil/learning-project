<template>
  <div :class="cardClasses">
    <div v-if="title || $slots.header" class="border-b border-gray-100 pb-4 mb-4">
      <slot name="header">
        <h3 class="text-xl font-semibold text-gray-900">{{ title }}</h3>
        <p v-if="subtitle" class="text-sm text-gray-500 mt-1">{{ subtitle }}</p>
      </slot>
    </div>
    
    <div class="card-body">
      <slot />
    </div>
    
    <div v-if="$slots.footer" class="border-t border-gray-100 pt-4 mt-4">
      <slot name="footer" />
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  title: {
    type: String,
    default: ''
  },
  subtitle: {
    type: String,
    default: ''
  },
  padding: {
    type: String,
    default: 'normal', // compact, normal, large
    validator: (value) => ['compact', 'normal', 'large'].includes(value)
  },
  hover: {
    type: Boolean,
    default: true
  }
})

const cardClasses = computed(() => {
  const base = 'bg-white rounded-lg shadow-md transition-shadow'
  
  const paddings = {
    compact: 'p-4',
    normal: 'p-6',
    large: 'p-8'
  }
  
  const hoverEffect = props.hover ? 'hover:shadow-lg' : ''
  
  return [base, paddings[props.padding], hoverEffect].join(' ')
})
</script>

