;; from http://www.ogre.com/node/447

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive
   (list (completing-read "Search for: " nil nil nil (current-word))))
  (grep-find (concat "git --no-pager grep -P -n "
                     search
                     " `git rev-parse --show-toplevel`")))

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(require 'json)

(defun yaml-to-json (path)
  (let* ((rb "ruby -ryaml -rjson -e 'puts JSON.dump YAML.load File.read ARGV.shift' ")
         (cmd (concat rb path)))
    (condition-case nil
        (json-read-from-string (shell-command-to-string cmd))
      (json-error nil))))

(defun get-hub-token ()
  (let* ((json (yaml-to-json "~/.config/hub"))
         (gh   (and json (alist-get 'github.com json))))
    (and gh (alist-get 'oauth_token (aref gh 0)))))

(setq magit-last-seen-setup-instructions "1.4.0")

;; http://endlessparentheses.com/automatically-configure-magit-to-access-github-prs.html

(defun endless/add-PR-fetch ()
  "If refs/pull is not defined on a GH repo, define it."
  (let ((fetch-address
         "+refs/pull/*/head:refs/pull/origin/*")
        (magit-remotes
         (magit-get-all "remote" "origin" "fetch")))
    (unless (or (not magit-remotes)
                (member fetch-address magit-remotes))
      (when (string-match
             "github" (magit-get "remote" "origin" "url"))
        (magit-git-string
         "config" "--add" "remote.origin.fetch"
         fetch-address)))))

;; (require 'magithub)
;; (magithub-feature-autoinject t)
