; -*- Mode: Lisp; Package: editor -*-

#|
= xyzzydiff - �R�}���h���C������w�肵���t�@�C���� diff ����

* Author:  MIYAMUKO Katsuyuki ((<URL:mailto:miyamuko@gmail.com>))
* URL: ((<URL:http://miyamuko.s56.xrea.com/xyzzy/xyzzydiff/intro.htm>))
* Version: $Id: xyzzydiff.l,v 1.3 2004/08/09 14:03:28 miyamuko Exp $


== ����

�R�}���h���C������w�肵�� 2 �̃t�@�C���� diff ���܂��B

  > xyzzydiff old-file new-file

((<"TortoiseCVS"|URL:http://www.tortoisecvs.org/>)) �� External diff application
�ȂǂɎw�肷��Ə����K���ɂȂ�܂��B

* �w�肵���t�@�C���� 1 �̏ꍇ�͕��ʂɊJ���܂��B
* �w�肵���t�@�C���� 3 �ȏ�̏ꍇ�͍ŏ��� 2 �� diff ���c��͕��ʂɊJ���܂��B
* -l �� -e �Ȃǂ̒ʏ�� xyzzy �̈����������Ɏw��\�ł��B


== �C���X�g�[��

((<NetInstaller|URL:http://www.mirai.ne.jp/~gyo/xyzzy/ni.html>)) �ŃC���X�g�[�������ꍇ��
4 �ȍ~�� OK �ł��B

(1) �A�[�J�C�u���_�E�����[�h���܂��B

    ((<URL:http://miyamuko.s56.xrea.com/xyzzy/archives/xyzzydiff.zip>))

(2) �A�[�J�C�u��W�J���āA$XYZZY/site-lisp �z���Ƀt�@�C�����R�s�[���܂��B

(3) xyzzycli.exe �� xyzzydiff.exe �Ƃ������O�ŃR�s�[���܂��B

(4) $XYZZY/site-lisp/siteinit.l �Ɉȉ��̃R�[�h��ǉ����܂��B

        ; xyzzydiff
        (require "xyzzydiff")

    ���K�� siteinit.l �ɒǉ����Ă��������B.xyzzy ���Ɠ��삵�܂���B

(5) �ݒ�𔽉f������ɂ� xyzzy ���ă_���v���Ă��������B

(6) ((%xyzzydiff oldfile newfile%)) �� diff �����܂��B


== ���t�@�����X

=== �ϐ�

--- *diff-command-line-hook*
    diff �̎��s�O�Ɏ��s����t�b�N�ł��B

    diff ����t�@�C���������� (old, new �̏�) �� run-hook-with-args �Ŏ��s���܂��B

    ��:
        (add-hook '*diff-command-line-hook* #'(lambda (old new)
                                                (msgbox "diff: ~A ~A" old new)))

=== xyzzydiff.ini

�ʏ�̐ݒ�ł͊��� xyzzy ���N�����Ă���ꍇ�A���� xyzzy �� diff �����s���܂��B
��� xyzzy ��V�K�ɋN���������ꍇ�� xyzzydiff.ini �� (({multipleInstances=1})) ��ݒ肵�Ă��������B

    [xyzzy]
    precedingOptions="-f diff-command-line-setup"
    followingOptions="-f diff-command-line-teardown"
    multipleInstances=1


== ���ꂩ���邩������Ȃ�����

* �Ȃ�?


== ���C�Z���X

xyzzydiff �͏C�� BSD ���C�Z���X�Ɋ�Â��ė��p�\�ł��B

  Copyright (C) 2003-2004 MIYAMUKO Katsuyuki. All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1 Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer as the first lines
    of this file unmodified.

  2 Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.
|#

(provide "xyzzydiff")
(in-package "editor")

(export '(diff-command-line-setup
          diff-command-line-teardown
          *diff-command-line-hook*))

(defvar *diff-command-line-hook* nil)
(defvar *diff-command-line-file-list* nil)

(defun diff-process-command-line (file)
  "�R�}���h���C���I�v�V�����������Ə������邽��
*process-command-line-hook* �œn���ꂽ����������
*diff-command-line-file-list* �ɏW�߂�B"
  (when (file-exist-p file)
    (setf *diff-command-line-file-list*
          (append *diff-command-line-file-list* (list file)))))

(defun diff-command-line-setup ()
  (setf *diff-command-line-file-list* nil)
  (add-hook '*process-command-line-hook* 'diff-process-command-line))

(defun diff-command-line-teardown ()
  "*diff-command-line-file-list* �ɍŏ��� 2 �̈����� diff ����B
�c��̈����͕��ʂɏ�������B"
  (delete-hook '*process-command-line-hook* 'diff-process-command-line)
  (when (<= 2 (length *diff-command-line-file-list*))
    (let ((old (pop *diff-command-line-file-list*))
          (new (pop *diff-command-line-file-list*)))
      (run-hook-with-args '*diff-command-line-hook* old new)
      ; xyzzy �� diff �� new old �̏�
      (diff new old)))
  (unless (zerop (length *diff-command-line-file-list*))
    (setf si:*command-line-args* *diff-command-line-file-list*)
    (process-command-line)))

;;
;; $Id: xyzzydiff.l,v 1.3 2004/08/09 14:03:28 miyamuko Exp $
;;