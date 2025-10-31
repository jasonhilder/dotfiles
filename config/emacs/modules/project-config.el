;; Projectile - project management
(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :config
  ;; Organize cache files
  (setq projectile-cache-file 
        (expand-file-name "var/projectile.cache" user-emacs-directory))
  (setq projectile-known-projects-file
        (expand-file-name "var/projectile-bookmarks.eld" user-emacs-directory))
  
  ;; Use default completion system (works with Vertico)
  (setq projectile-completion-system 'default)
  
  ;; Cache project files for better performance
  (setq projectile-enable-caching t)
  
  ;; Show project root in switch-project
  (setq projectile-switch-project-action #'projectile-dired)
  
  ;; Indexing method (alien works well with git projects)
  (setq projectile-indexing-method 'alien)
  
  ;; Define project root markers
  (setq projectile-project-root-files-bottom-up
        '(".projectile" ".git" ".hg" ".svn" ".bzr" "_darcs"))
  
  ;; Windows-specific: use native indexing to avoid Unix command dependencies
  (when (eq system-type 'windows-nt)
    ;; Use ripgrep for finding project files if available
    (if (executable-find "rg")
        (setq projectile-git-command "rg --files --hidden -0 --no-ignore-vcs"
              projectile-generic-command "rg --files --hidden -0 --no-ignore-vcs")
      ;; Fallback to native indexing if rg not installed
      (setq projectile-indexing-method 'native
            projectile-generic-command "dir /s /b")))
  
  ;; Unix/Mac: Use fd for faster file finding if available
  (when (and (not (eq system-type 'windows-nt))
             (executable-find "fd"))
    (setq projectile-git-command "fd . -0 --type f --color=never"
          projectile-generic-command "fd . -0 --type f --color=never")))

;; Consult-Projectile - Vertico/Consult integration for Projectile
(use-package consult-projectile
  :ensure t
  :after (projectile consult)
  :config
  ;; Add projectile to consult-buffer sources
  (setq consult-projectile-sources
        '(consult-projectile--source-projectile-buffer
          consult-projectile--source-projectile-file
          consult-projectile--source-projectile-project)))

;; Keybindings are defined in evil-config.el:
;;
;; "p f" 'projectile-find-file              ; Find file in project (works with Vertico)
;; "p p" 'projectile-switch-project         ; Switch project
;; "p s" 'consult-ripgrep                   ; Search in project (requires ripgrep)
;; "p g" 'consult-git-grep                  ; Git grep in project
;; "p b" 'consult-project-buffer            ; Switch to project buffer
;; "p d" 'projectile-dired                  ; Open project root in dired
;; "p k" 'projectile-kill-buffers           ; Kill all project buffers
;; "p r" 'projectile-recentf                ; Recent files in project
;; "p i" 'projectile-invalidate-cache       ; Refresh project file cache

;; Optional: ripgrep for faster project searching
;; (use-package rg
;;   :ensure t
;;   :config
;;   (rg-enable-default-bindings))

(provide 'project-config)
;;; project-config.el ends here
