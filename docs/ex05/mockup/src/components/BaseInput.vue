<template>
  <div class="w-full">
    <label v-if="label" :for="id" class="block text-sm font-medium text-gray-700 mb-2">
      {{ label }}
      <span v-if="required" class="text-red-500">*</span>
    </label>
    
    <input
      v-if="type !== 'textarea'"
      :id="id"
      :type="type"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :class="inputClasses"
      @input="$emit('update:modelValue', $event.target.value)"
      @blur="$emit('blur')"
      @focus="$emit('focus')"
    />
    
    <textarea
      v-else
      :id="id"
      :value="modelValue"
      :placeholder="placeholder"
      :disabled="disabled"
      :rows="rows"
      :class="inputClasses"
      @input="$emit('update:modelValue', $event.target.value)"
      @blur="$emit('blur')"
      @focus="$emit('focus')"
    ></textarea>
    
    <p v-if="error" class="mt-1 text-sm text-red-500">{{ error }}</p>
    <p v-else-if="hint" class="mt-1 text-sm text-gray-500">{{ hint }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  id: {
    type: String,
    required: true
  },
  modelValue: {
    type: [String, Number],
    default: ''
  },
  type: {
    type: String,
    default: 'text'
  },
  label: {
    type: String,
    default: ''
  },
  placeholder: {
    type: String,
    default: ''
  },
  error: {
    type: String,
    default: ''
  },
  hint: {
    type: String,
    default: ''
  },
  disabled: {
    type: Boolean,
    default: false
  },
  required: {
    type: Boolean,
    default: false
  },
  rows: {
    type: Number,
    default: 4
  }
})

defineEmits(['update:modelValue', 'blur', 'focus'])

const inputClasses = computed(() => {
  const base = 'w-full px-4 border rounded-2xl outline-none transition-all'
  const height = props.type === 'textarea' ? 'py-3' : 'h-12'
  const state = props.error
    ? 'border-red-500 focus:border-red-500 focus:ring-2 focus:ring-red-200'
    : 'border-gray-200 focus:border-primary focus:ring-2 focus:ring-primary/20'
  const disabled = props.disabled ? 'bg-gray-100 cursor-not-allowed' : 'bg-white'
  
  return [base, height, state, disabled].join(' ')
})
</script>

