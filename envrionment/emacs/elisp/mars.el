;; "mars.el v1.1" Copyright (C) Kenji KATO (kato@suri.co.jp) 23/Nov/1993 
;;   This software is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY.  No author or distributor accepts responsibility
;; to anyone for the consequences of using it or for whether it serves
;; any particular purpose or works at all, unless he says so in writing.
;; Refer to the GNU Emacs General Public License for full details.
;;   Everyone is granted permission to copy, modify and redistribute this
;; software, but only under the conditions described in the GNU Emacs
;; General Public License.  A copy of this license is supposed to have
;; been given to you along with this software so you can know your rights
;; and responsibilities.  It should be in a file named COPYING. If not,
;; write to the Free Software Foundation, 675 Mass Ave, Cambridge, MA
;; 02139, USA.  Among other things, the copyright notice and this notice
;; must be preserved on all copies.

(defvar mars:string              nil)
(defvar mars:prev-win-conf       nil)
(defvar mars:prev-bufname        nil)
(defvar mars:phobos-map          nil)
(defvar mars:deimos-map          nil)
(defvar phobos:error-previous    nil)
(defvar phobos:error-next        nil)

(if mars:phobos-map
    ()
  (setq mars:phobos-map (make-sparse-keymap))
  (define-key mars:phobos-map " "     'phobos:goto-deimos)
  (define-key mars:phobos-map "m"     'phobos:goto-deimos)
  (define-key mars:phobos-map "\C-c"  'phobos:akuryo-taisan)
  (define-key mars:phobos-map "n"     'phobos:next-line)
  (define-key mars:phobos-map "j"     'phobos:next-line)
  (define-key mars:phobos-map "p"     'phobos:previous-line)
  (define-key mars:phobos-map "k"     'phobos:previous-line)
  (define-key mars:phobos-map "h"     'phobos:help)
  (define-key mars:phobos-map "q"     'mars:quit))

(if mars:deimos-map
    ()
  (setq mars:deimos-map (make-sparse-keymap))
  (define-key mars:deimos-map "."     'deimos:fire-soul)
  (define-key mars:deimos-map " "     'deimos:burning-mandara)
  (define-key mars:deimos-map "n"     'deimos:next-line)
  (define-key mars:deimos-map "j"     'deimos:next-line)
  (define-key mars:deimos-map "p"     'deimos:previous-line)
  (define-key mars:deimos-map "k"     'deimos:previous-line)
  (define-key mars:deimos-map "m"     'deimos:goto-phobos)
  (define-key mars:deimos-map "b"     'deimos:goto-phobos-2)
  (define-key mars:deimos-map "h"     'deimos:help)
  (define-key mars:deimos-map "x"     'deimos:exit)
  (define-key mars:deimos-map "q"     'mars:quit))

(defun mars (dir &optional command string) 
  (interactive "Ddirectory: ")
  (setq mars:prev-bufname (buffer-name (current-buffer)))
  (if (not command) (setq command mars:command))
  (setq mars:prev-win-conf (current-window-configuration))
  (let ((buf "*Mars*") proc)
    (if string
	(setq mars:string string)
      (setq string (mars:current))
      (setq mars:string "")
      (while (string= mars:string "")
	(setq mars:string 
	      (read-from-minibuffer
	       (concat "default \"" string "\": ")))
	(if (string= mars:string "") (setq mars:string string))))
    (delete-other-windows)
;    (split-window)
    (switch-to-buffer (get-buffer-create buf))
    (if (processp (get-process "*Reichan*")) 
	(delete-process "*Reichan*"))
    (setq buffer-read-only nil)
    (erase-buffer)
    (setq buffer-read-only t)
    (setq proc (start-process "*Reichan*" nil command dir mars:string))
    (set-process-buffer   proc (current-buffer))
    (set-process-filter   proc 'mars:reichan-filter)
    (set-process-sentinel proc 'mars:reichan-sentinel)
    (use-local-map mars:phobos-map)
    (setq major-mode 'phobos:mode-help)
    (setq mode-name "Phobos")))

(defun mars:reichan-filter (proc string)
  (interactive)
  (let ((buf (get-buffer "*Mars*")))
    (if (not buf)
	(message "Buffer *Mars* killed")
      (set-buffer buf)
      (setq buffer-read-only nil)
      (save-excursion
	(goto-char (point-max))
	(insert string))
      (setq buffer-read-only t))))

(defun mars:reichan-sentinel (proc string)
  (interactive)
  (let ((buf (get-buffer "*Mars*")))
    (if (not buf)
	(message "Buffer *Mars* killed")
      (set-buffer buf)
      (setq buffer-read-only nil)
      (save-excursion
	(goto-char (point-max))
	(insert "\nProcess *Mars:find-grep* " string))
      (setq buffer-read-only t))))

(defun mars:quit ()
  (interactive)
  (mars:kill-buffer "*Mars*")
  (mars:kill-buffer "*Occur*")
  (set-window-configuration mars:prev-win-conf)
  (delete-other-windows))

(defun mars:start-occur ()
  (goto-char (point-min))
  (occur mars:string)
  (switch-to-buffer (get-buffer "*Occur*"))
  (setq buffer-read-only t)
  (use-local-map mars:deimos-map) 
  (setq major-mode 'deimos:mode-help)
  (setq mode-name "Deimos")
  (delete-other-windows)
  (if (<= (window-width) 140)
      (split-window (get-buffer-window (current-buffer)) 9))
  )

(defun mars:current () 
  (save-excursion
    (while (and (not (bolp)) 
		(not (mars:tokenp)))
      (backward-char))
    (while (and (not (bolp))
		(mars:tokenp))
      (backward-char))
    (while (and (not (eolp))
		(not (mars:tokenp))) 
      (forward-char))
    (let ((tp (point)))
      (while (and (not (eolp))
		  (mars:tokenp))
	(forward-char))
      (buffer-substring tp (point)))))

(defun mars:tokenp ()
  (if (eobp) 
      nil
    (let ((ch (char-after (point))))
      (if (string= mode-name "Emacs-Lisp")
	  (cond
	   ((and (>= ch 33) (<= ch  38)))
	   ((and (>= ch 42) (<= ch  45)))
	   ((and (>= ch 47) (<= ch  58)))
	   ((and (>= ch 60) (<= ch  62)))
	   ((and (>= ch 64) (<= ch  90)))
	   ((= ch 92))
	   ((and (>= ch 94) (<= ch 126)))
	   (t nil))
	(cond 
	 ((= ch 45))
	 ((and (>= ch 48) (<= ch  57)))
	 ((and (>= ch 65) (<= ch  90)))
	 ((= ch 95))
	 ((and (>= ch 97) (<= ch 122)))
	 (t nil))))))

(defun mars:kill-buffer (string)
  (let ((tb (get-buffer string)))
    (if (and tb (bufferp tb))
	(kill-buffer tb))))

(defun phobos:next-line ()
  (interactive)
  (setq phobos:error-previous nil)
  (let ((pp (point))
	tp
	(fname ""))
    (if phobos:error-next
	(goto-char (point-min)))
    (while (and (or (string= fname "")
		    (not (file-exists-p fname)))
		(not (eobp)))
      (forward-line 1)
      (setq tp (point))
      (end-of-line)
      (setq fname (buffer-substring tp (point)))
      (beginning-of-line))
    (if (not (eobp))
	(setq phobos:error-next nil)
      (beep)
      (goto-char pp)
      (setq phobos:error-next t))))

(defun phobos:previous-line ()
  (interactive)
  (setq phobos:error-next nil)
  (let ((pp (point))
	tp
	(fname ""))
    (if phobos:error-previous
	(goto-char (point-max)))
    (while (and (or (string= fname "")
		    (not (file-exists-p fname)))
		(not (bobp)))
      (forward-line -1)
      (setq tp (point))
      (end-of-line)
      (setq fname (buffer-substring tp (point)))
      (beginning-of-line))
    (if (not (bobp))
	(setq phobos:error-previous nil)
      (beep)
      (goto-char pp)
      (setq phobos:error-previous t))))

(defun phobos:goto-deimos ()
  (interactive)
  (beginning-of-line)
  (let ((tp (point)) fname)
    (end-of-line)
    (setq fname (buffer-substring tp (point)))
    (beginning-of-line)
    (if (or (not (file-exists-p fname)) (string= fname "")) 
	(message "Illegal file name")
      (find-file fname)
      (mars:start-occur)
      (deimos:fire-soul 2)
      (sit-for 1)
      (other-window 1))))

(defun phobos:akuryo-taisan ()
  (interactive)
  (if (and "*Reichan*" (string= (process-status "*Reichan*") "run"))
      (kill-process "*Reichan*")))

(defun phobos:help () 
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ (phobos:mode-help))
    (print-help-return-message)))

(defun phobos:mode-help ()
  "\
\"*Mars*\"バッファ（Phobosモード）でのコマンド\n\
\n\
  SPACE,m  指定行のファイルをオープンしてoccurを実行\n\
  C-c      find-grep プロセスの中断\n\
  n,j      次のファイル名のある行へ\n\
  p,k      前のファイル名のある行へ\n\
  h        ヘルプメッセージの表示\n\
  q        終了")

(defun deimos ()
  (interactive)
  (setq mars:prev-bufname (buffer-name (current-buffer)))
  (setq mars:prev-win-conf (current-window-configuration))
  (let ((string (mars:current)))
    (setq mars:string "")
    (while (string= mars:string "")
      (setq mars:string 
	    (read-from-minibuffer
	     (concat "default \"" string "\": ")))
      (if (string= mars:string "") (setq mars:string string))))
  (mars:start-occur)
  (deimos:fire-soul 2)
  (if (or (eobp) (bobp))
      (progn
	(message "Not found")
	(set-window-configuration mars:prev-win-conf))
    (sit-for 1)
    (other-window 1)))

(defun deimos:fire-soul (&optional lnum) 
  (interactive)
  (if lnum (goto-line lnum))
  (if (eobp)
      ()
    (occur-mode-goto-occurrence)
    (re-search-forward mars:string (min (+ (point) 80) (point-max)) t)
    (setq search-last-string mars:string)))

(defun deimos:burning-mandara ()
  (interactive)
  (deimos:fire-soul)
  (sit-for 1)
  (other-window 1))

(defun deimos:goto-phobos ()
  (interactive)
  (let ((buf (get-buffer "*Mars*"))
	cbufname)
    (if (not buf)
	(message "buffer *Mars* not exists")
      (other-window 1)
      (setq cbufname (buffer-name (current-buffer)))
      (if (not (string= cbufname mars:prev-bufname))
	  (kill-buffer (current-buffer)))
      (switch-to-buffer buf)
      (delete-other-windows))))

(defun deimos:goto-phobos-2 ()
  (interactive)
  (let ((buf (get-buffer "*Mars*"))
	cbufname)
    (if (not buf)
	(message "buffer *Mars* not exists")
      (switch-to-buffer buf)
      (delete-other-windows))))

(defun deimos:previous-line ()
  (interactive)
  (if (bobp) (goto-char (point-max)))
  (forward-line -1)
  (if (bobp)
      (beep)
    (deimos:fire-soul)
    (sit-for 1)
    (other-window 1)))
  
(defun deimos:next-line ()
  (interactive)
  (if (eobp) (goto-char (point-min)))
  (forward-line 1)
  (if (eobp)
      (beep)
    (deimos:fire-soul)
    (sit-for 1)
    (other-window 1)))

(defun deimos:exit ()
  (interactive)
  (deimos:fire-soul)
  (delete-other-windows)
  (mars:kill-buffer "*Mars*")
  (mars:kill-buffer "*Occur*"))

(defun deimos:help () 
  (interactive)
  (with-output-to-temp-buffer "*Help*"
    (princ (deimos:mode-help))
    (print-help-return-message)))

(defun deimos:mode-help ()
  "\
\"*Occur*\"バッファ（Deimosモード）でのコマンド\n\
\n\
  .      参照箇所へジャンプ\n\
  SPACE  参照箇所へジャンプした後 *Occur* バッファへ戻る\n\
  n,j    次の参照箇所へジャンプした後 *Occur* バッファへ戻る\n\
  p,k    前の参照箇所へジャンプした後 *Occur* バッファへ戻る\n\
  m      現在参照しているバッファを消去し *Mars* バッファを表示\n\
  b      現在参照しているバッファを消去せず *Mars* バッファを表示\n\
  h      ヘルプメッセージの表示\n\
  x      参照箇所へジャンプし終了\n\
  q      終了")  
