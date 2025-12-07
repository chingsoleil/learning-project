<template>
  <div class="min-h-screen bg-gray-50">
    <!-- Navigation -->
    <nav class="bg-white shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16 items-center">
          <button @click="goBack" class="text-gray-600 hover:text-primary">
            ← 返回
          </button>
          <h1 class="text-xl font-bold text-primary">詳細報告</h1>
          <button @click="downloadPDF" class="text-sm text-secondary hover:underline">
            下載 PDF
          </button>
        </div>
      </div>
    </nav>

    <div class="max-w-4xl mx-auto px-4 py-8">
      <!-- Verification (if not verified) -->
      <BaseCard v-if="!isVerified" class="mb-6">
        <h3 class="text-xl font-semibold text-gray-900 mb-4">驗證身份</h3>
        <p class="text-gray-600 mb-6">請輸入您的聯絡資訊以查看完整報告</p>
        
        <form @submit.prevent="handleVerify" class="space-y-4">
          <BaseInput
            id="verify-email"
            v-model="verifyEmail"
            type="email"
            label="Email"
            placeholder="example@email.com"
            :required="true"
          />
          
          <BaseButton type="submit" class="w-full" :loading="isVerifying">
            驗證並查看
          </BaseButton>
        </form>
      </BaseCard>

      <div v-else>
        <!-- Report Header -->
        <BaseCard class="mb-6">
          <div class="text-center">
            <h2 class="text-2xl font-bold text-gray-900 mb-2">大五人格測驗完整報告</h2>
            <p class="text-gray-600">Session #{{ sessionId }}</p>
            <p class="text-sm text-gray-500 mt-1">{{ completedTime }}</p>
          </div>
        </BaseCard>

        <!-- Dimension Analysis Sections -->
        <div class="space-y-6 mb-8">
          <BaseCard v-for="(dimension, index) in dimensions" :key="dimension.id">
            <div class="cursor-pointer" @click="toggleSection(index)">
              <div class="flex items-center justify-between">
                <div class="flex items-center flex-1">
                  <span class="text-3xl mr-4">{{ dimension.icon }}</span>
                  <div>
                    <h3 class="text-xl font-semibold text-gray-900">
                      {{ dimension.nameZh }} ({{ dimension.nameEn }})
                    </h3>
                    <p class="text-sm text-gray-600">{{ dimension.subtitle }}</p>
                  </div>
                </div>
                <div class="flex items-center">
                  <div class="text-right mr-4">
                    <p class="text-2xl font-bold text-primary">{{ dimension.score.rawScore }}/50</p>
                    <p class="text-sm text-gray-600">百分位: {{ dimension.score.percentile }}%</p>
                  </div>
                  <span class="text-2xl text-gray-400">{{ expandedSections[index] ? '▼' : '▶' }}</span>
                </div>
              </div>
            </div>

            <Transition name="expand">
              <div v-if="expandedSections[index]" class="mt-6 pt-6 border-t border-gray-200">
                <!-- Score Bar -->
                <div class="mb-6">
                  <div class="flex justify-between text-sm mb-2">
                    <span class="text-gray-600">分數分布</span>
                    <span class="font-semibold">{{ dimension.score.level }}</span>
                  </div>
                  <div class="w-full bg-gray-200 rounded-full h-3">
                    <div class="bg-primary h-3 rounded-full transition-all" 
                         :style="{ width: (dimension.score.rawScore / 50 * 100) + '%' }"></div>
                  </div>
                  <div class="flex justify-between text-xs text-gray-500 mt-1">
                    <span>低分</span>
                    <span>中分</span>
                    <span>高分</span>
                  </div>
                </div>

                <!-- Detailed Analysis -->
                <div class="space-y-6">
                  <div>
                    <h4 class="font-semibold text-gray-900 mb-2">🎯 您的特質表現</h4>
                    <p class="text-gray-700 leading-relaxed">{{ dimension.analysis.traits }}</p>
                  </div>

                  <div>
                    <h4 class="font-semibold text-gray-900 mb-2">💪 優勢與特點</h4>
                    <ul class="list-disc list-inside space-y-1 text-gray-700">
                      <li v-for="(strength, i) in dimension.analysis.strengths" :key="i">
                        {{ strength }}
                      </li>
                    </ul>
                  </div>

                  <div>
                    <h4 class="font-semibold text-gray-900 mb-2">⚠️ 可能的挑戰</h4>
                    <ul class="list-disc list-inside space-y-1 text-gray-700">
                      <li v-for="(challenge, i) in dimension.analysis.challenges" :key="i">
                        {{ challenge }}
                      </li>
                    </ul>
                  </div>

                  <div>
                    <h4 class="font-semibold text-gray-900 mb-2">📈 建議與發展方向</h4>
                    <p class="text-gray-700 leading-relaxed">{{ dimension.analysis.suggestions }}</p>
                  </div>
                </div>
              </div>
            </Transition>
          </BaseCard>
        </div>

        <!-- Cross-Dimensional Analysis -->
        <BaseCard class="mb-6">
          <h3 class="text-xl font-semibold text-gray-900 mb-4">🔄 維度交互分析</h3>
          <p class="text-gray-700 leading-relaxed mb-4">
            您的人格特質組合（高嚴謹性 + 高親和性 + 中高外向性）顯示您是一個既注重細節、
            又善於與人合作的人。這種組合在需要團隊協作的專業環境中特別有價值。
          </p>
          <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded">
            <p class="text-sm font-semibold text-blue-900 mb-1">💡 人格類型建議</p>
            <p class="text-sm text-blue-800">
              您可能屬於「協調者」類型：能夠在維持高標準的同時，也能照顧到團隊成員的需求。
              這種特質在管理、教育和諮詢領域特別受到重視。
            </p>
          </div>
        </BaseCard>

        <!-- Career Suggestions -->
        <BaseCard class="mb-6">
          <h3 class="text-xl font-semibold text-gray-900 mb-4">💼 職涯建議</h3>
          <div class="mb-4">
            <h4 class="font-semibold text-gray-900 mb-2">適合的職業類型</h4>
            <div class="flex flex-wrap gap-2">
              <span v-for="career in careers" :key="career" 
                    class="px-3 py-1 bg-primary/10 text-primary rounded-full text-sm">
                {{ career }}
              </span>
            </div>
          </div>
          <div>
            <h4 class="font-semibold text-gray-900 mb-2">工作風格建議</h4>
            <ul class="list-disc list-inside space-y-1 text-gray-700">
              <li>在結構化的環境中表現最佳，但也能適應一定的變化</li>
              <li>喜歡團隊合作，但也需要獨立完成任務的空間</li>
              <li>重視與同事建立良好關係，同時也注重工作成果</li>
              <li>適合需要溝通協調與專案管理的角色</li>
            </ul>
          </div>
        </BaseCard>

        <!-- Relationship Suggestions -->
        <BaseCard class="mb-6">
          <h3 class="text-xl font-semibold text-gray-900 mb-4">🤝 人際關係建議</h3>
          <div class="space-y-4">
            <div>
              <h4 class="font-semibold text-gray-900 mb-2">溝通風格</h4>
              <p class="text-gray-700">
                您傾向於以友善、尊重的方式與他人溝通。您善於傾聽他人意見，
                也能清楚表達自己的想法。建議在面對衝突時，保持開放態度但也要堅持原則。
              </p>
            </div>
            <div>
              <h4 class="font-semibold text-gray-900 mb-2">相處建議</h4>
              <p class="text-gray-700">
                與他人相處時，您的親和力是很大的優勢。但也要注意不要過度迎合他人而忽略自己的需求。
                適度地表達自己的意見和界線，反而能建立更健康的人際關係。
              </p>
            </div>
          </div>
        </BaseCard>

        <!-- Personal Growth -->
        <BaseCard class="mb-8">
          <h3 class="text-xl font-semibold text-gray-900 mb-4">🌱 個人成長建議</h3>
          <div class="space-y-3">
            <div class="flex items-start">
              <span class="text-primary mr-2">•</span>
              <p class="text-gray-700">持續培養開放性，嘗試接觸不同領域的知識和體驗</p>
            </div>
            <div class="flex items-start">
              <span class="text-primary mr-2">•</span>
              <p class="text-gray-700">適度放鬆嚴謹性標準，學會在必要時「足夠好就好」</p>
            </div>
            <div class="flex items-start">
              <span class="text-primary mr-2">•</span>
              <p class="text-gray-700">平衡社交與獨處時間，確保有足夠的自我充電時間</p>
            </div>
            <div class="flex items-start">
              <span class="text-primary mr-2">•</span>
              <p class="text-gray-700">練習情緒覺察，更深入了解自己的情緒模式</p>
            </div>
          </div>
        </BaseCard>

        <!-- Consultation Form -->
        <BaseCard>
          <h3 class="text-xl font-semibold text-gray-900 mb-4">💬 需要專業諮詢？</h3>
          <p class="text-gray-600 mb-6">如果您對測驗結果有任何疑問，歡迎填寫諮詢表單，我們的專業團隊將盡快回覆您。</p>
          
          <form @submit.prevent="handleConsultation" class="space-y-4">
            <BaseInput
              id="consult-title"
              v-model="consultForm.title"
              label="諮詢標題"
              placeholder="請簡述您的問題"
              :required="true"
            />

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                諮詢類別 <span class="text-red-500">*</span>
              </label>
              <select v-model="consultForm.category" 
                      class="input-field"
                      required>
                <option value="">請選擇</option>
                <option value="測驗結果解讀">測驗結果解讀</option>
                <option value="職業發展諮詢">職業發展諮詢</option>
                <option value="人際關係輔導">人際關係輔導</option>
                <option value="個人成長規劃">個人成長規劃</option>
                <option value="其他問題">其他問題</option>
              </select>
            </div>

            <BaseInput
              id="consult-content"
              v-model="consultForm.content"
              type="textarea"
              label="諮詢內容"
              placeholder="請詳細描述您的問題或需求（50-500字）"
              :required="true"
              :rows="6"
            />

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                聯絡方式 <span class="text-red-500">*</span>
              </label>
              <div class="flex gap-4">
                <label class="flex items-center">
                  <input type="radio" v-model="consultForm.contactMethod" value="Email" 
                         class="mr-2" required />
                  <span>Email</span>
                </label>
                <label class="flex items-center">
                  <input type="radio" v-model="consultForm.contactMethod" value="Phone" 
                         class="mr-2" />
                  <span>電話</span>
                </label>
                <label class="flex items-center">
                  <input type="radio" v-model="consultForm.contactMethod" value="Line" 
                         class="mr-2" />
                  <span>Line</span>
                </label>
              </div>
            </div>

            <div>
              <label class="block text-sm font-medium text-gray-700 mb-2">
                方便聯絡時間 <span class="text-red-500">*</span>
              </label>
              <div class="grid grid-cols-2 gap-2">
                <label class="flex items-center">
                  <input type="checkbox" v-model="consultForm.preferredTime" 
                         value="weekday-morning" class="mr-2" />
                  <span class="text-sm">平日上午 (9:00-12:00)</span>
                </label>
                <label class="flex items-center">
                  <input type="checkbox" v-model="consultForm.preferredTime" 
                         value="weekday-afternoon" class="mr-2" />
                  <span class="text-sm">平日下午 (13:00-18:00)</span>
                </label>
                <label class="flex items-center">
                  <input type="checkbox" v-model="consultForm.preferredTime" 
                         value="weekday-evening" class="mr-2" />
                  <span class="text-sm">平日晚上 (18:00-21:00)</span>
                </label>
                <label class="flex items-center">
                  <input type="checkbox" v-model="consultForm.preferredTime" 
                         value="weekend" class="mr-2" />
                  <span class="text-sm">週末時段</span>
                </label>
              </div>
            </div>

            <BaseButton type="submit" class="w-full" :loading="isSubmittingConsult">
              送出諮詢
            </BaseButton>
          </form>
        </BaseCard>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import BaseCard from '../components/BaseCard.vue'
import BaseInput from '../components/BaseInput.vue'
import BaseButton from '../components/BaseButton.vue'

const route = useRoute()
const router = useRouter()

const sessionId = ref(route.params.sessionId)
const isVerified = ref(true) // In real app, check authentication
const isVerifying = ref(false)
const verifyEmail = ref('')

const expandedSections = ref([true, false, false, false, false])

const completedTime = computed(() => {
  return new Date().toLocaleString('zh-TW', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
})

const dimensions = ref([
  {
    id: 'openness',
    nameZh: '經驗開放性',
    nameEn: 'Openness',
    icon: '🎨',
    subtitle: '想像力、好奇心、創造力',
    score: { rawScore: 38, percentile: 75, level: '高' },
    analysis: {
      traits: '您展現出對新體驗的開放態度和豐富的想像力。您喜歡探索新的想法、嘗試不同的事物，並對藝術和創意活動有濃厚興趣。這種特質使您在面對變化時能夠保持彈性，並且樂於接受新的挑戰。',
      strengths: [
        '富有創造力和想像力',
        '對新事物保持好奇心',
        '能夠欣賞藝術和美學',
        '思維靈活，適應力強'
      ],
      challenges: [
        '有時可能過於理想化',
        '可能不喜歡過度結構化的環境',
        '需要平衡創新與實用性'
      ],
      suggestions: '繼續培養您的創造力，但也要注意將想法轉化為實際行動。可以嘗試參加藝術或創意相關的活動，同時也要學習在必要時接受傳統或標準的做法。'
    }
  },
  {
    id: 'conscientiousness',
    nameZh: '嚴謹性',
    nameEn: 'Conscientiousness',
    icon: '📋',
    subtitle: '組織性、責任感、自律',
    score: { rawScore: 42, percentile: 85, level: '高' },
    analysis: {
      traits: '您是一個非常有組織、可靠且自律的人。您注重細節，喜歡規劃，並且會認真完成承諾的事情。這種特質使您在工作和生活中都能保持高標準，並且能夠有效管理時間和資源。',
      strengths: [
        '高度負責任和可靠',
        '善於組織和規劃',
        '注重細節和品質',
        '能夠堅持長期目標'
      ],
      challenges: [
        '可能過於追求完美',
        '有時會過度計劃而缺乏彈性',
        '可能對自己和他人要求過高'
      ],
      suggestions: '您的嚴謹性是很大的優勢，但也要學會適度放鬆。有時候「足夠好」就已經很好了，不需要追求百分之百的完美。給自己一些喘息空間，也能讓您更有創造力。'
    }
  },
  {
    id: 'extraversion',
    nameZh: '外向性',
    nameEn: 'Extraversion',
    icon: '🎉',
    subtitle: '社交性、活力、積極情緒',
    score: { rawScore: 35, percentile: 70, level: '中高' },
    analysis: {
      traits: '您在社交場合中表現得當，能夠與他人建立良好關係。雖然您享受社交互動，但也需要一些獨處時間來充電。這種平衡的外向性使您能夠適應各種社交環境。',
      strengths: [
        '能夠輕鬆與人交流',
        '在團隊中積極參與',
        '善於建立人際網絡',
        '能夠平衡社交與獨處'
      ],
      challenges: [
        '有時可能需要更多獨處時間',
        '在大型社交場合可能會感到疲倦',
        '需要找到社交與充電的平衡'
      ],
      suggestions: '繼續發展您的社交技能，但也要尊重自己對獨處時間的需求。學會辨識什麼時候需要社交，什麼時候需要休息，這樣能讓您在人際互動中更加自在。'
    }
  },
  {
    id: 'agreeableness',
    nameZh: '親和性',
    nameEn: 'Agreeableness',
    icon: '🤝',
    subtitle: '信任、利他、合作',
    score: { rawScore: 40, percentile: 80, level: '高' },
    analysis: {
      traits: '您是一個善良、有同理心且樂於助人的人。您重視和諧的人際關係，善於合作，並且能夠考慮他人的感受。這種特質使您在團隊中很受歡迎，也容易獲得他人的信任。',
      strengths: [
        '富有同理心和善良',
        '善於團隊合作',
        '能夠建立信任關係',
        '樂於幫助他人'
      ],
      challenges: [
        '可能過度迎合他人',
        '有時難以說不',
        '可能忽略自己的需求',
        '在衝突中可能過於退讓'
      ],
      suggestions: '您的親和力是很棒的特質，但也要學會適度堅持自己的立場。說「不」並不代表不友善，反而能建立更健康的界線。在幫助他人的同時，也要照顧好自己的需求。'
    }
  },
  {
    id: 'neuroticism',
    nameZh: '神經質',
    nameEn: 'Neuroticism',
    icon: '😰',
    subtitle: '焦慮、情緒不穩定、壓力反應',
    score: { rawScore: 25, percentile: 45, level: '中' },
    analysis: {
      traits: '您的情緒相對穩定，能夠有效處理日常壓力。雖然偶爾會感到焦慮或擔憂，但通常能夠保持冷靜並找到解決方法。這種情緒穩定性幫助您在面對挑戰時保持清晰的思維。',
      strengths: [
        '情緒相對穩定',
        '能夠冷靜應對壓力',
        '較少被負面情緒影響',
        '能夠理性處理問題'
      ],
      challenges: [
        '偶爾可能低估壓力的影響',
        '可能不夠重視情緒健康',
        '在極度壓力下可能失去平衡'
      ],
      suggestions: '繼續保持您的情緒穩定性，但也要注意情緒健康的重要性。定期檢視自己的壓力水平，培養健康的壓力管理方式，如運動、冥想或興趣愛好，能讓您更長期地維持良好狀態。'
    }
  }
])

const careers = ref([
  '專案管理',
  '人力資源',
  '教育工作',
  '諮詢顧問',
  '社工',
  '醫療保健',
  '客戶服務',
  '行政管理'
])

const consultForm = reactive({
  title: '',
  category: '',
  content: '',
  contactMethod: 'Email',
  preferredTime: []
})

const isSubmittingConsult = ref(false)

function toggleSection(index) {
  expandedSections.value[index] = !expandedSections.value[index]
}

function goBack() {
  router.push(`/test/big-five/result/${sessionId.value}`)
}

function downloadPDF() {
  alert('PDF 下載功能將在實際開發時實作')
}

async function handleVerify() {
  isVerifying.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  isVerified.value = true
  isVerifying.value = false
}

async function handleConsultation() {
  if (!consultForm.title || !consultForm.category || !consultForm.content || 
      !consultForm.contactMethod || consultForm.preferredTime.length === 0) {
    alert('請填寫所有必填欄位')
    return
  }

  if (consultForm.content.length < 50) {
    alert('諮詢內容至少需要 50 字')
    return
  }

  isSubmittingConsult.value = true
  await new Promise(resolve => setTimeout(resolve, 1000))
  isSubmittingConsult.value = false
  
  alert('諮詢已送出！我們會盡快與您聯繫。')
  
  // Reset form
  Object.keys(consultForm).forEach(key => {
    if (key === 'preferredTime') {
      consultForm[key] = []
    } else if (key === 'contactMethod') {
      consultForm[key] = 'Email'
    } else {
      consultForm[key] = ''
    }
  })
}
</script>

<style scoped>
.expand-enter-active,
.expand-leave-active {
  transition: all 0.3s ease;
  overflow: hidden;
}

.expand-enter-from,
.expand-leave-to {
  opacity: 0;
  max-height: 0;
}

.expand-enter-to,
.expand-leave-from {
  opacity: 1;
  max-height: 2000px;
}
</style>

