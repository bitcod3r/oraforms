for i in `cat por_migrar.txt` 
do
	
	/home/oracle/Oracle/Middleware/asinst_1/bin/frmcmp_batch.sh module=$i userid=usuario/Passwd@fdbbkp compile_all=yes > resultadox.txt
	out=$(grep "Created form file" resultadox.txt)
	
	if [[ "$out" == *Created*form*file* ]]
	then
		echo "$out";
		echo "$out" >> fmigradas.txt;
		mv resultadox.txt	$i.migrated
	else
		echo "Error en forma $i.fmb";
		echo $i >> ferrores.txt;
		mv resultadox.txt	$i.error
	fi

	
done

echo "-------------------";
echo "RESULTADOS FINALES:";
echo "-------------------";
echo $(wc -l por_migrar.txt);
echo "-------------------";
echo $(cat ferrores.txt | wc -l) " + " $(wc -l fmigradas.txt)

