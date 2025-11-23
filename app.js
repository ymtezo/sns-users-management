// SNS User Management System
class SNSUserManager {
    constructor() {
        this.users = [];
        this.relationships = []; // {follower: userId, following: userId}
        this.posts = []; // {userId, content, likes}
        this.currentPlatform = 'twitter';
        this.init();
    }

    init() {
        this.loadData();
        this.setupEventListeners();
        this.renderUsers();
    }

    setupEventListeners() {
        // Add user form
        document.getElementById('addUserForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addUser(e.target);
        });

        // Follow relationship form
        document.getElementById('followForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addRelationship(e.target);
        });

        // Platform selector
        document.querySelectorAll('.platform-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                if (!e.target.disabled) {
                    document.querySelectorAll('.platform-btn').forEach(b => b.classList.remove('active'));
                    e.target.classList.add('active');
                    this.currentPlatform = e.target.dataset.platform;
                    this.renderUsers();
                }
            });
        });
    }

    addUser(form) {
        const formData = new FormData(form);
        const interests = formData.get('interests').split(',').map(i => i.trim()).filter(i => i);
        const attributes = formData.get('attributes').split(',').map(a => a.trim()).filter(a => a);

        const user = {
            id: Date.now().toString(),
            platform: this.currentPlatform,
            username: formData.get('username'),
            displayName: formData.get('displayName'),
            bio: formData.get('bio'),
            interests: interests,
            interestDetails: formData.get('interestDetails'),
            attributes: attributes,
            createdAt: new Date().toISOString()
        };

        this.users.push(user);
        
        // Add sample posts for demonstration
        this.addSamplePosts(user.id);
        
        this.saveData();
        this.renderUsers();
        form.reset();
        
        alert(`ユーザー「${user.displayName}」を追加しました！`);
    }

    addSamplePosts(userId) {
        const samplePosts = [
            { content: '新しいプロジェクトを始めました！', likes: Math.floor(Math.random() * 100) },
            { content: 'SNSユーザ管理システムについて考えています', likes: Math.floor(Math.random() * 50) }
        ];

        samplePosts.forEach(post => {
            this.posts.push({
                id: Date.now().toString() + Math.random(),
                userId: userId,
                content: post.content,
                likes: post.likes,
                createdAt: new Date().toISOString()
            });
        });
    }

    addRelationship(form) {
        const formData = new FormData(form);
        const follower = formData.get('followerSelect');
        const following = formData.get('followingSelect');

        if (follower === following) {
            alert('同じユーザーを選択することはできません');
            return;
        }

        // Check if relationship already exists
        const exists = this.relationships.some(r => 
            r.follower === follower && r.following === following
        );

        if (exists) {
            alert('このフォロー関係は既に存在します');
            return;
        }

        this.relationships.push({
            follower: follower,
            following: following,
            createdAt: new Date().toISOString()
        });

        this.saveData();
        this.renderUsers();
        form.reset();
        
        alert('フォロー関係を追加しました！');
    }

    getFollowingCount(userId) {
        return this.relationships.filter(r => r.follower === userId).length;
    }

    getFollowersCount(userId) {
        return this.relationships.filter(r => r.following === userId).length;
    }

    getUserPosts(userId) {
        return this.posts.filter(p => p.userId === userId).slice(0, 3); // Top 3 posts
    }

    renderUsers() {
        const usersList = document.getElementById('usersList');
        const followerSelect = document.getElementById('followerSelect');
        const followingSelect = document.getElementById('followingSelect');

        // Filter users by current platform
        const platformUsers = this.users.filter(u => u.platform === this.currentPlatform);

        if (platformUsers.length === 0) {
            usersList.innerHTML = '<div class="empty-state">まだユーザーが登録されていません</div>';
            followerSelect.innerHTML = '<option value="">選択してください</option>';
            followingSelect.innerHTML = '<option value="">選択してください</option>';
            return;
        }

        // Render user cards
        usersList.innerHTML = platformUsers.map(user => this.renderUserCard(user)).join('');

        // Update select options
        const options = platformUsers.map(user => 
            `<option value="${user.id}">${user.displayName} (@${user.username})</option>`
        ).join('');
        
        followerSelect.innerHTML = '<option value="">選択してください</option>' + options;
        followingSelect.innerHTML = '<option value="">選択してください</option>' + options;

        // Add delete button listeners
        document.querySelectorAll('.btn-delete').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const userId = e.target.dataset.userId;
                this.deleteUser(userId);
            });
        });
    }

    renderUserCard(user) {
        const followingCount = this.getFollowingCount(user.id);
        const followersCount = this.getFollowersCount(user.id);
        const userPosts = this.getUserPosts(user.id);
        const initial = user.displayName.charAt(0).toUpperCase();

        return `
            <div class="user-card" data-user-id="${user.id}">
                <div class="user-header">
                    <div class="user-avatar">${initial}</div>
                    <div class="user-info">
                        <h3>${user.displayName}</h3>
                        <div class="user-handle">@${user.username}</div>
                    </div>
                </div>
                
                ${user.bio ? `<div class="user-bio">${user.bio}</div>` : ''}
                
                ${user.interests.length > 0 ? `
                    <div class="user-interests">
                        <h4>興味・関心</h4>
                        <div class="tags">
                            ${user.interests.map(interest => 
                                `<span class="tag interest">${interest}</span>`
                            ).join('')}
                        </div>
                    </div>
                ` : ''}
                
                ${user.interestDetails ? `
                    <div class="interest-details">
                        <strong>興味の詳細:</strong> ${user.interestDetails}
                    </div>
                ` : ''}
                
                ${user.attributes.length > 0 ? `
                    <div class="user-attributes">
                        <h4>属性</h4>
                        <div class="tags">
                            ${user.attributes.map(attr => 
                                `<span class="tag attribute">${attr}</span>`
                            ).join('')}
                        </div>
                    </div>
                ` : ''}
                
                <div class="user-relationships">
                    <div class="relationship-stat">
                        <strong>${followingCount}</strong> <span>フォロー中</span>
                    </div>
                    <div class="relationship-stat">
                        <strong>${followersCount}</strong> <span>フォロワー</span>
                    </div>
                </div>
                
                ${userPosts.length > 0 ? `
                    <div class="user-posts">
                        <h4>主要な投稿</h4>
                        ${userPosts.map(post => `
                            <div class="post-item">
                                ${post.content}
                                <div class="post-likes">❤️ ${post.likes} いいね</div>
                            </div>
                        `).join('')}
                    </div>
                ` : ''}
                
                <button class="btn-delete" data-user-id="${user.id}">削除</button>
            </div>
        `;
    }

    deleteUser(userId) {
        if (!confirm('このユーザーを削除してもよろしいですか？')) {
            return;
        }

        // Remove user
        this.users = this.users.filter(u => u.id !== userId);
        
        // Remove relationships
        this.relationships = this.relationships.filter(r => 
            r.follower !== userId && r.following !== userId
        );
        
        // Remove posts
        this.posts = this.posts.filter(p => p.userId !== userId);
        
        this.saveData();
        this.renderUsers();
        
        alert('ユーザーを削除しました');
    }

    saveData() {
        localStorage.setItem('snsUsers', JSON.stringify(this.users));
        localStorage.setItem('snsRelationships', JSON.stringify(this.relationships));
        localStorage.setItem('snsPosts', JSON.stringify(this.posts));
    }

    loadData() {
        try {
            const users = localStorage.getItem('snsUsers');
            const relationships = localStorage.getItem('snsRelationships');
            const posts = localStorage.getItem('snsPosts');

            if (users) this.users = JSON.parse(users);
            if (relationships) this.relationships = JSON.parse(relationships);
            if (posts) this.posts = JSON.parse(posts);
        } catch (error) {
            console.error('Failed to load data from localStorage:', error);
            // Reset to empty state if data is corrupted
            this.users = [];
            this.relationships = [];
            this.posts = [];
        }
    }
}

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    new SNSUserManager();
});
