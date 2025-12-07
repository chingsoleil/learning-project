<template>
  <button
    :class="buttonClasses"
    :disabled="disabled || loading"
    @click="handleClick"
  >
    <span v-if="loading" class="animate-spin mr-2">⌛</span>
    <slot />
  </button>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  variant: {
    type: String,
    default: 'primary', // primary, secondary, danger, ghost
    validator: (value) => ['primary', 'secondary', 'danger', 'ghost'].includes(value)
  },
  size: {
    type: String,
    default: 'regular', // small, regular, large
    validator: (value) => ['small', 'regular', 'large'].includes(value)
  },
  disabled: {
    type: Boolean,
    default: false
  },
  loading: {
    type: Boolean,
    default: false
  },
  fullWidth: {
    type: Boolean,
    default: false
  }
})

const emit = defineEmits(['click'])

const buttonClasses = computed(() => {
  const base = 'font-medium rounded-lg transition-all duration-300 flex items-center justify-center'
  
  const sizes = {
    small: 'h-10 px-4 text-sm',
    regular: 'h-12 px-6 text-base',
    large: 'h-14 px-8 text-lg'
  }
  
  const variants = {
    primary: 'bg-primary text-white hover:bg-primary/90 active:scale-95',
    secondary: 'bg-white border-2 border-primary text-primary hover:bg-gray-50',
    danger: 'bg-red-500 text-white hover:bg-red-600 active:scale-95',
    ghost: 'bg-transparent text-primary hover:bg-gray-100'
  }
  
  const width = props.fullWidth ? 'w-full' : ''
  const disabledClass = props.disabled || props.loading ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'
  
  return [base, sizes[props.size], variants[props.variant], width, disabledClass].join(' ')
})

function handleClick(event) {
  if (!props.disabled && !props.loading) {
    emit('click', event)
  }
}
</script>

