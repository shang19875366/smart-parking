import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/C/Home.vue')
  },
  {
    path: '/b',
    name: 'b',
    component: () => import('../views/B/Layout.vue'),
    children: [
      {
        path: 'parking',
        name: 'b-parking',
        component: () => import('../views/B/Parking.vue')
      },
      {
        path: 'report',
        name: 'b-report',
        component: () => import('../views/B/Report.vue')
      },
      {
        path: 'comment',
        name: 'b-comment',
        component: () => import('../views/B/Comment.vue')
      },
      {
        path: 'audit',
        name: 'b-audit',
        component: () => import('../views/B/Audit.vue')
      }
    ]
  },
  {
    path: '/c',
    name: 'c',
    component: () => import('../views/C/Layout.vue'),
    children: [
      {
        path: 'map',
        name: 'c-map',
        component: () => import('../views/C/Map.vue')
      },
      {
        path: 'report',
        name: 'c-report',
        component: () => import('../views/C/Report.vue')
      },
      {
        path: 'detail/:id',
        name: 'c-detail',
        component: () => import('../views/C/Detail.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router