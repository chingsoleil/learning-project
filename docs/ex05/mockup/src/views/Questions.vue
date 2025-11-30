<template>
  <div class="min-h-screen bg-gray-50 pb-20">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <button @click="handleBack" class="text-gray-600 hover:text-primary">
            ← 返回
          </button>
          <button 
            @click="showQuestionList = !showQuestionList"
            class="md:hidden text-gray-600 hover:text-primary"
          >
            📋 題目列表
          </button>
        </div>
      </div>
    </nav>

    <!-- Progress Indicator -->
    <div class="max-w-7xl mx-auto px-4 py-6">
      <div class="flex items-center justify-between mb-2">
        <span class="text-sm text-gray-400">1. 個人資訊</span>
        <span class="text-sm font-medium text-primary">2. 答題</span>
        <span class="text-sm text-gray-400">3. 結果</span>
      </div>
      <div class="w-full bg-gray-200 rounded-full h-2">
        <div class="bg-primary h-2 rounded-full transition-all duration-300" 
             :style="{ width: testStore.progress + '%' }"></div>
      </div>
      <p class="text-sm text-gray-600 mt-2 text-center">
        已完成 {{ testStore.answeredCount }} / {{ testStore.totalQuestions }} 題
        ({{ testStore.progress }}%)
      </p>
    </div>

    <div class="max-w-7xl mx-auto px-4 py-4">
      <div class="flex gap-6">
        <!-- Question List Sidebar (Desktop) -->
        <div class="hidden md:block w-64 flex-shrink-0">
          <BaseCard padding="compact" class="sticky top-4">
            <h3 class="font-semibold text-gray-900 mb-4">題目清單</h3>
            <div class="grid grid-cols-5 gap-2 max-h-96 overflow-y-auto">
              <button
                v-for="(question, index) in questions"
                :key="question.id"
                @click="testStore.goToQuestion(index)"
                class="w-10 h-10 rounded-lg flex items-center justify-center text-sm font-medium transition-all"
                :class="getQuestionButtonClass(question.id, index)"
              >
                {{ index + 1 }}
              </button>
            </div>
          </BaseCard>
        </div>

        <!-- Main Question Area -->
        <div class="flex-1">
          <BaseCard v-if="currentQuestion" class="mb-6">
            <div class="mb-6">
              <div class="flex items-center justify-between mb-4">
                <span class="text-sm font-medium text-gray-500">
                  第 {{ testStore.currentQuestionIndex + 1 }} 題
                </span>
                <span class="text-sm text-gray-400">
                  {{ getDimensionName(currentQuestion.dimension) }}
                </span>
              </div>
              
              <h2 class="text-xl md:text-2xl font-semibold text-gray-900 mb-8">
                {{ currentQuestion.textZh }}
              </h2>

              <!-- Answer Options -->
              <div class="space-y-3">
                <label
                  v-for="option in answerOptions"
                  :key="option.value"
                  class="flex items-center p-4 border-2 rounded-lg cursor-pointer transition-all"
                  :class="getAnswerClass(option.value)"
                >
                  <input
                    type="radio"
                    :name="'question-' + currentQuestion.id"
                    :value="option.value"
                    v-model="currentAnswer"
                    @change="handleAnswer(option.value)"
                    class="sr-only"
                  />
                  <span class="flex-shrink-0 w-8 h-8 rounded-full border-2 flex items-center justify-center mr-4"
                        :class="currentAnswer === option.value 
                          ? 'border-primary bg-primary text-white' 
                          : 'border-gray-300'">
                    <span v-if="currentAnswer === option.value">✓</span>
                    <span v-else class="text-gray-400">{{ option.value }}</span>
                  </span>
                  <span class="flex-1 text-lg">{{ option.label }}</span>
                </label>
              </div>
            </div>

            <!-- Navigation Buttons -->
            <div class="flex gap-4 pt-6 border-t">
              <BaseButton
                variant="secondary"
                @click="testStore.previousQuestion()"
                :disabled="testStore.currentQuestionIndex === 0"
                class="flex-1"
              >
                ← 上一題
              </BaseButton>
              <BaseButton
                v-if="testStore.currentQuestionIndex < testStore.totalQuestions - 1"
                @click="testStore.nextQuestion()"
                class="flex-1"
              >
                下一題 →
              </BaseButton>
              <BaseButton
                v-else
                @click="handleSubmit"
                :disabled="!testStore.isAllAnswered"
                class="flex-1"
              >
                送出測驗 ✓
              </BaseButton>
            </div>
          </BaseCard>
        </div>
      </div>
    </div>

    <!-- Mobile Question List Drawer -->
    <Transition name="slide-up">
      <div v-if="showQuestionList" 
           class="md:hidden fixed inset-0 z-50 bg-black/50"
           @click="showQuestionList = false">
        <div class="absolute bottom-0 left-0 right-0 bg-white rounded-t-2xl p-6 max-h-[70vh] overflow-y-auto"
             @click.stop>
          <div class="flex justify-between items-center mb-4">
            <h3 class="font-semibold text-gray-900">題目清單</h3>
            <button @click="showQuestionList = false" class="text-2xl">×</button>
          </div>
          <div class="grid grid-cols-5 gap-3">
            <button
              v-for="(question, index) in questions"
              :key="question.id"
              @click="goToQuestionAndClose(index)"
              class="h-12 rounded-lg flex items-center justify-center text-sm font-medium"
              :class="getQuestionButtonClass(question.id, index)"
            >
              {{ index + 1 }}
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useTestStore } from '../stores/test'
import BaseCard from '../components/BaseCard.vue'
import BaseButton from '../components/BaseButton.vue'
import questionsData from '../data/big-five-questions.json'

const router = useRouter()
const testStore = useTestStore()

const showQuestionList = ref(false)
const questions = ref(questionsData.questions)
const answerOptions = ref(questionsData.answerOptions)

const currentQuestion = computed(() => {
  return questions.value[testStore.currentQuestionIndex]
})

const currentAnswer = computed({
  get() {
    return testStore.answers[currentQuestion.value?.id] || null
  },
  set(value) {
    // Handled by handleAnswer
  }
})

onMounted(() => {
  testStore.setTest(questionsData)
  testStore.loadFromLocalStorage()
  
  // Warn before leaving
  window.addEventListener('beforeunload', handleBeforeUnload)
})

function handleBeforeUnload(e) {
  if (testStore.answeredCount > 0 && testStore.answeredCount < testStore.totalQuestions) {
    e.preventDefault()
    e.returnValue = ''
  }
}

function getDimensionName(dimensionId) {
  const dimension = questionsData.dimensions.find(d => d.id === dimensionId)
  return dimension?.nameZh || ''
}

function getAnswerClass(value) {
  if (currentAnswer.value === value) {
    return 'border-primary bg-primary/5'
  }
  return 'border-gray-200 hover:border-primary/50'
}

function getQuestionButtonClass(questionId, index) {
  const isAnswered = testStore.answers[questionId] !== undefined
  const isCurrent = index === testStore.currentQuestionIndex
  
  if (isCurrent) {
    return 'bg-primary text-white border-2 border-primary'
  } else if (isAnswered) {
    return 'bg-green-500 text-white'
  } else {
    return 'bg-gray-100 text-gray-600 hover:bg-gray-200'
  }
}

function handleAnswer(value) {
  testStore.setAnswer(currentQuestion.value.id, value)
}

function goToQuestionAndClose(index) {
  testStore.goToQuestion(index)
  showQuestionList.value = false
}

function handleBack() {
  if (testStore.answeredCount > 0) {
    if (confirm('確定要離開嗎？進度將會儲存到瀏覽器，但建議一次完成測驗。')) {
      router.push('/test/big-five/user-info')
    }
  } else {
    router.push('/test/big-five/user-info')
  }
}

async function handleSubmit() {
  if (!testStore.isAllAnswered) {
    alert('請完成所有題目後再送出')
    return
  }
  
  if (confirm('確定要送出測驗嗎？送出後將無法修改答案。')) {
    // Calculate scores (simplified)
    const mockSessionId = Date.now()
    
    // Navigate to result page
    router.push(`/test/big-five/result/${mockSessionId}`)
  }
}
</script>

<style scoped>
.slide-up-enter-active,
.slide-up-leave-active {
  transition: all 0.3s ease;
}

.slide-up-enter-from,
.slide-up-leave-to {
  opacity: 0;
}

.slide-up-enter-from > div,
.slide-up-leave-to > div {
  transform: translateY(100%);
}
</style>

