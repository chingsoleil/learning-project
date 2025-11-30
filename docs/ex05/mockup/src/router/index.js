import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    // 使用者受測頁面
    {
      path: '/',
      name: 'home',
      component: () => import('../views/Home.vue')
    },
    {
      path: '/test/big-five-intro',
      name: 'test-intro',
      component: () => import('../views/TestIntro.vue')
    },
    {
      path: '/test/big-five/user-info',
      name: 'user-info',
      component: () => import('../views/UserInfo.vue')
    },
    {
      path: '/test/big-five/questions',
      name: 'questions',
      component: () => import('../views/Questions.vue')
    },
    {
      path: '/test/big-five/result/:sessionId',
      name: 'result',
      component: () => import('../views/TestResult.vue')
    },
    {
      path: '/report/detail/:sessionId',
      name: 'report-detail',
      component: () => import('../views/DetailedReport.vue')
    },
    {
      path: '/report/history',
      name: 'test-history',
      component: () => import('../views/TestHistory.vue')
    },
    
    // 管理系統頁面
    {
      path: '/admin',
      redirect: '/admin/login'
    },
    {
      path: '/admin/login',
      name: 'admin-login',
      component: () => import('../views/admin/Login.vue')
    },
    {
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      component: () => import('../views/admin/Dashboard.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/tests',
      name: 'admin-tests',
      component: () => import('../views/admin/TestManagement.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/questions/:testId',
      name: 'admin-questions',
      component: () => import('../views/admin/QuestionManagement.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/users',
      name: 'admin-users',
      component: () => import('../views/admin/UserManagement.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/consultations',
      name: 'admin-consultations',
      component: () => import('../views/admin/ConsultationManagement.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/reports',
      name: 'admin-reports',
      component: () => import('../views/admin/ReportManagement.vue'),
      meta: { requiresAuth: true }
    },
    {
      path: '/admin/settings',
      name: 'admin-settings',
      component: () => import('../views/admin/Settings.vue'),
      meta: { requiresAuth: true }
    }
  ]
})

// 路由守衛
router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('adminToken')
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ name: 'admin-login' })
  } else {
    next()
  }
})

export default router

