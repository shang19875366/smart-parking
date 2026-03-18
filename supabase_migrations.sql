-- 创建停车场表
CREATE TABLE parking_lots (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 6) NOT NULL,
  longitude DECIMAL(10, 6) NOT NULL,
  fee DECIMAL(5, 2) NOT NULL,
  phone VARCHAR(20),
  status VARCHAR(20) DEFAULT 'active',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 创建用户上报表
CREATE TABLE user_reports (
  id SERIAL PRIMARY KEY,
  parking_id INTEGER REFERENCES parking_lots(id),
  name VARCHAR(255) NOT NULL,
  address VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 6) NOT NULL,
  longitude DECIMAL(10, 6) NOT NULL,
  fee DECIMAL(5, 2) NOT NULL,
  phone VARCHAR(20),
  remark TEXT,
  user_name VARCHAR(100) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 创建评论表
CREATE TABLE comments (
  id SERIAL PRIMARY KEY,
  parking_id INTEGER REFERENCES parking_lots(id),
  user_name VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 创建审核表
CREATE TABLE audits (
  id SERIAL PRIMARY KEY,
  report_id INTEGER REFERENCES user_reports(id),
  type VARCHAR(20) NOT NULL,
  content TEXT NOT NULL,
  user_name VARCHAR(100) NOT NULL,
  status VARCHAR(20) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- 创建索引
CREATE INDEX idx_parking_lots_location ON parking_lots(latitude, longitude);
CREATE INDEX idx_user_reports_status ON user_reports(status);
CREATE INDEX idx_comments_parking_id ON comments(parking_id);
CREATE INDEX idx_audits_status ON audits(status);