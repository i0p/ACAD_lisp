(defun c:DeleteAllWipeouts (/ ss i ent obj blk blocks count)

  (vl-load-com)
  (setq count 0)

  ;; Удаляем WIPEOUT из пространства модели и листов
  (if (setq ss (ssget "_X" '((0 . "WIPEOUT"))))
    (progn
      (setq i 0)
      (while (< i (sslength ss))
        (setq ent (ssname ss i))
        (if (entdel ent)
          (setq count (1+ count))
        )
        (setq i (1+ i))
      )
    )
  )

  ;; Получаем все определения блоков
  (setq blocks (vla-get-Blocks
                 (vla-get-ActiveDocument
                   (vlax-get-acad-object))))

  ;; Удаляем WIPEOUT из определений блоков
  (vlax-for blk blocks
    (if (and
          (= :vlax-false (vla-get-IsLayout blk))
          (= :vlax-false (vla-get-IsXRef blk))
        )
      (progn
        (setq obj nil)
        (vlax-for obj blk
          (if (= "AcDbWipeout" (vla-get-ObjectName obj))
            (progn
              (vla-delete obj)
              (setq count (1+ count))
            )
          )
        )
      )
    )
  )

  (princ
    (strcat
      "\nУдалено WIPEOUT: "
      (itoa count)
    )
  )
  (princ)
)