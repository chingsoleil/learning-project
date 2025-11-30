import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useTestStore = defineStore('test', () => {
  // State
  const currentTest = ref(null)
  const userInfo = ref(null)
  const answers = ref({})
  const currentQuestionIndex = ref(0)

  // Getters
  const totalQuestions = computed(() => {
    return currentTest.value?.questions?.length || 0
  })

  const answeredCount = computed(() => {
    return Object.keys(answers.value).length
  })

  const progress = computed(() => {
    if (totalQuestions.value === 0) return 0
    return Math.round((answeredCount.value / totalQuestions.value) * 100)
  })

  const isAllAnswered = computed(() => {
    return answeredCount.value === totalQuestions.value
  })

  // Actions
  function setTest(test) {
    currentTest.value = test
  }

  function setUserInfo(info) {
    userInfo.value = info
  }

  function setAnswer(questionId, value) {
    answers.value[questionId] = value
    saveToLocalStorage()
  }

  function goToQuestion(index) {
    if (index >= 0 && index < totalQuestions.value) {
      currentQuestionIndex.value = index
    }
  }

  function nextQuestion() {
    if (currentQuestionIndex.value < totalQuestions.value - 1) {
      currentQuestionIndex.value++
    }
  }

  function previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--
    }
  }

  function saveToLocalStorage() {
    localStorage.setItem('testProgress', JSON.stringify({
      userInfo: userInfo.value,
      answers: answers.value,
      currentQuestionIndex: currentQuestionIndex.value,
      timestamp: new Date().toISOString()
    }))
  }

  function loadFromLocalStorage() {
    const saved = localStorage.getItem('testProgress')
    if (saved) {
      const data = JSON.parse(saved)
      userInfo.value = data.userInfo
      answers.value = data.answers || {}
      currentQuestionIndex.value = data.currentQuestionIndex || 0
    }
  }

  function reset() {
    currentTest.value = null
    userInfo.value = null
    answers.value = {}
    currentQuestionIndex.value = 0
    localStorage.removeItem('testProgress')
  }

  return {
    // State
    currentTest,
    userInfo,
    answers,
    currentQuestionIndex,
    // Getters
    totalQuestions,
    answeredCount,
    progress,
    isAllAnswered,
    // Actions
    setTest,
    setUserInfo,
    setAnswer,
    goToQuestion,
    nextQuestion,
    previousQuestion,
    saveToLocalStorage,
    loadFromLocalStorage,
    reset
  }
})

