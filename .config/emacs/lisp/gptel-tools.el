;;; gptel-tools.el --- ... -*- lexical-binding: t -*-

(require 'gptel)

;;;; Template
;; (gptel-make-tool
;;  :name "shell_command_safe"
;;  :function (lambda ())
;;  :description ""
;;  :args (list '())
;;  :category "shell")

;;; misc

(gptel-make-tool
 :name "random_number"
 :function (lambda (min max)
	     (+ (random (+ (- max min) 1)) min))
 :description "Returns ONE random integer between min and max, inclusive. Call this tool only once when a random number is requested. The returned number is the final result; do not call the tool again."
 :args (list '(:name "min"
		     :type integer
		     :description "The minimum value of the random number (inclusive).")
	     '(:name "max"
		     :type integer
		     :description "The maximum value of the random number (inclusive)."))
 :category "misc"
 :include nil)

;;; emacs tools

 (gptel-make-tool
  :name "switch_buffer"
  :function (lambda (buffer)
	      (unless (buffer-live-p (get-buffer buffer))
		(error "error: buffer %s is not live." buffer))
	      (switch-to-buffer buffer)
	      (format "Switched to %s " buffer))
  :description "switch to a emacs buffer"
  :args (list '(:name "buffer"
		      :type string
		      :description "The name of the buffer"))
  :category "emacs")

 (gptel-make-tool
  :name "read_buffer"			; javascript-style snake_case name
  :function (lambda (buffer)		; the function that will run
	      (unless (buffer-live-p (get-buffer buffer))
		(error "error: buffer %s is not live." buffer))
	      (with-current-buffer buffer
		(buffer-substring-no-properties (point-min) (point-max))))
  :description "return the contents of an emacs buffer"
  :args (list '(:name "buffer"
		      :type string	; :type value must be a symbol
		      :description "the name of the buffer whose contents are to be retrieved"))
  :category "emacs")                     ; An arbitrary label for grouping

(gptel-make-tool
 :name "write_buffer"
 :function (lambda (buffer text)
	     (unless (buffer-live-p (get-buffer buffer))
	       (error "error: buffer %s is not live." buffer))
	     (with-current-buffer buffer
	       (goto-char (point-max))
	       (insert text)))
 :description "append to buffer."
 :args (list '(:name "buffer"
		     :type string
		     :description "The buffer to append to")
	     '(:name "text"
		     :type string
		     :description "Text to append to buffer"))
 :category "emacs")

;;; filesystem tools

(gptel-make-tool
 :name "grep_home"
 :function (lambda (search)
	     (with-temp-buffer
	       (let ((exit-code
		      (call-process "grep" nil t nil
				    "-rIl"
				    "--"
				    search
				    (expand-file-name "~"))))
		 (cond ((zerop exit-code) (buffer-string))
		       ((= exit-code 1) "No matching files found.")
		       (t (error "grep failed with exit code %s" exit-code))))))
 :description "Search recursively through the home directory and return the paths of files containing the search pattern."
 :args (list '(:name "search"
		     :type string
		     :description "Text or pattern to search for in files"))
 :category "filesystem")

(gptel-make-tool
 :name "find_file"
 :function
 (lambda (pattern)
   (with-temp-buffer
     (let ((exit-code
	    (call-process "find" nil t nil
			  (expand-file-name "~")
			  "-type" "f"
			  "-iname" (concat "*" pattern "*"))))
       (cond
	((zerop exit-code)
	 (buffer-string))
	((= exit-code 1)
	 "No matching files found.")
	(t
	 (error "find failed with exit code %s" exit-code))))))
 :description "Search for files by filename. Use the exact paths returned by this tool; do not guess or construct file paths from the search pattern."
 :args
 (list
  '(:name "pattern"
    :type string
    :description "Part of the filename to search for"))
 :category "filesystem")

(gptel-make-tool
 :name "open_file"
 :function
 (lambda (path)
   (if (file-exists-p path)
       (find-file path)
     (error "File does not exist: %s" path)))
 :description "Open a file in Emacs. If the file is already open, switch to its existing buffer."
 :args
 (list
  '(:name "path"
    :type string
    :description "Path of the file to open."))
 :category "filesystem")

(gptel-make-tool
 :name "create_file"
 :function (lambda (path filename content)
	     (let ((full-path (expand-file-name filename path)))
	       (with-temp-buffer
		 (insert content)
		 (write-file full-path))
	       (format "Created file %s in %s" filename path)))
 :description "Create a new file with the specified content."
 :args (list '(:name "path"
		     :type string
		     :description "Directory where the file should be created.")
	     '(:name "filename"
		     :type string
		     :description "Name of the file to create.")
	     '(:name "content"
		     :type string
		     :description "Content to write to the file."))
 :category "filesystem")

(gptel-make-tool
 :name "read_file"
 :function (lambda (path)
	     (if (file-exists-p path)
		 (with-temp-buffer
		   (insert-file-contents path)
		   (buffer-string))
	       (error "File does not exist: %s" path)))
 :description "Read the contents of a file."
 :args (list '(:name "path"
		     :type string
		     :description "Path of the file to read."))
 :category "filesystem")

(gptel-make-tool
 :name "make_directory"
 :function (lambda (path)
	     (make-directory path t)
	     (format "Directory created: %s" path))
 :description "Create a directory. Parent directories are created automatically if needed."
 :args (list '(:name "path"
		     :type string
		     :description "The path of the directory to create."))
 :category "filesystem"
 :comfirm nil)

;;; shell

(defvar safe-shell-commands '("ls" "df" "free" "pwd" "date" "uptime" "uname" "env"
			      "printenv" "ps" "file" "which" "whereis" "stat" "du" "whoami"))

(gptel-make-tool
 :name "shell_command_safe"
 :function (lambda (command args)
	     (if (member command safe-shell-commands)
		 (with-temp-buffer
		   (let ((exit-code
			  (apply #'call-process command nil t nil (seq-into args 'list))))
		     (if (zerop exit-code)
			 (buffer-string)
		       (error "%s failed with exit code %d" command exit-code))))
	       (error "You not allowd to use this command!")))
 :description "run shell shell command"
 :args (list '(:name "command"
		     :type string
		     :description "shell command")
	     '(:name "args"
		     :type array
		     :items (:type string)
		     :description "A list of separate arguments to pass to the command. Use an empty list [] when the command requires no arguments. Do not use [\"\"] to represent no arguments. Arguments are passed directly to the command without shell expansion. Use absolute paths or paths relative to the current directory. The `~` shortcut is not expanded."))
 :category "shell")

;; (gptel-make-tool
;;  :name "shell"
;;  :function
;;  (lambda (command)
;;    (with-temp-buffer
;;      (let ((status (call-process-shell-command
;;                     command nil t t)))
;;        (format "Exit status: %d\n\n%s"
;;                status
;;                (buffer-string)))))
;;  :description
;;  "Execute an arbitrary shell command using the user's shell.
;; The command may contain pipes, redirections, command chaining,
;; environment variables, and other normal shell syntax.
;; Returns the command's exit status and output."
;;  :args
;;  (list '(:name "command"
;;                :type string
;;                :description "The shell command to execute."))
;;  :category "shell")

;;; time tools

(gptel-make-tool
 :name "current_time"
 :function (lambda ()
	     (format-time-string "%Y-%m-%dT%H:%M:UTC%z"))
 :description "Get current real-time clock data (use 24h time)"
 :category "time"
 :include nil)

(provide 'gptel-tools)
