function [ratio] = f( S, RawMaterials, bPlot )
% ���Ŀ�꺯��
% input��S�����ϼ��ϣ������ϵ�һ�����򣩣�RawMaterials��ԭ�ϳߴ磻 bPlot���Ƿ񻭳��и�ͼ
% output��ratio�����������ԭ������ı�ֵ��1��ʾ���е�ԭ�϶����˷ѣ�0��ʾ���˷ѡ�
   
    nNum = max(size(S(:,1)));
    
    index = 1;
    nR = 1;
    a = RawMaterials(1);       %ԭ�ϵĳ���
    b = RawMaterials(2);       %ԭ�ϵĿ��
    
    % ԭ���ϲü����ľ��μ���
    % R(i)�Ľṹ:  x1; y1; x2; y2; bUsed; indexS; bCross.  bUsed��ʾ�þ����Ƿ��ù���false��δ�ù���
    % indexS ��ʾ��Ӧ�Ĳ�Ʒ�����S(k)��k��bCross ��ʾ�þ���δ�ù�ʱ���Ƿ�������������ص����֣�false��û�С�
    R(1).x1 = 0;
    R(1).y1 = 0;
    R(1).x2 = a;
    R(1).y2 = b;
    R(1).bUsed = false;
    R(1).indexS = 0;
    R(1).bCross = false;
    error = 0.01;
    
    if bPlot == true
         plot([0 a a 0 0], [0, 0, b, b, 0], 'r')
         hold on;
    end

    for k=1:1:nNum
        
        %���S(k,:)����ѡ�п����ɵľ���R��i��
        [ i Sk] = SelectRi( R, S(k,:), error);
        
        %û���ҵ���ǰ��Ʒ����Ӧ��ԭ�ϼ���������ǰ��Ʒ����������һ����Ʒ��
        if i == 0
            continue;
        end
        
        %��ѡ�о��κ����������н��沿��
        if R(i).bCross == true
            for j=1:1:nR
                if ( R(j).bCross == true && j~=i )
                     %R(j) = R(j) - Com( R(i), R(j) );
                     [Cx1 Cy1 Cx2 Cy2] = Com( R(i), R(j) );
                     
                     if j > i
                         R(j).x2 = Cx1;
                         R(j).y2 = Cy2;        
                     else
                         R(j).x2 = Cx2;
                         R(j).y2 = Cy1;
                     end
                     
                     if (R(j).x2 < R(j).x1) || (R(j).y2 < R(j).y1)
                          dddd = 1;
                     end
                     
                     R(j).bCross = false;
                     R(i).bCross = false;
                     break;
                end
            end
        %��ѡ�о��κ���������û�н��沿�֣�������������໥��������Ҳ����û���໥�����        
        else 
            kk = 0;
            for j=1:1:nR
                if ( R(j).bCross == true)
                    kk = kk + 1;
                    Cr(kk) = j;
                    if kk == 2
                        break;
                    end
                end
            end
            
            if kk == 2

                j1 = Cr(1);
                S1 = ( R(j1).x2 - R(j1).x1 ) * ( R(j1).y2 - R(j1).y1 );
            
                j2 = Cr(2);
                S2 = ( R(j2).x2 - R(j2).x1 ) * ( R(j2).y2 - R(j2).y1 );
                
                m = 0;
                if (S1 >= S2)
                    m = j2;
                else
                    m = j1;
                end
            
                [Cx1 Cy1 Cx2 Cy2] = Com( R(j1), R(j2) );
                if m == max(j1, j2)
                    R(m).x2 = Cx1;
                    R(m).y2 = Cy2;    
                elseif m == min(j1, j2)
                    R(m).x2 = Cx2;
                    R(m).y2 = Cy1;
                end
            
                R(j1).bCross = false;
                R(j2).bCross = false;
            end
            
        end   %end of "if R(i).bCross == true"

        % �����µ���������
        c = Sk(1);
        d = Sk(2);
        
        Rcr1.x1 = R(i).x1+c;
        Rcr1.y1 = R(i).y1;
        Rcr1.x2 = R(i).x2;
        Rcr1.y2 = R(i).y2;
        Rcr1.bUsed = false;
        Rcr1.indexS = 0;
        Rcr1.bCross = true;
        
        Rcr2.x1 = R(i).x1;
        Rcr2.y1 = R(i).y1+d;
        Rcr2.x2 = R(i).x2;
        Rcr2.y2 = R(i).y2;
        Rcr2.bUsed = false;
        Rcr2.indexS = 0;
        Rcr2.bCross = true;
        
        bTrim1 = false;
        bTrim2 = false;
        
        if ( Rcr1.x2-Rcr1.x1<error || Rcr1.y2-Rcr1.y1<error )
            bTrim1 = true;
            Rcr2.bCross = false;
        end
        
        if ( Rcr2.x2-Rcr2.x1<error || Rcr2.y2-Rcr2.y1<error )
            bTrim2 = true;
            Rcr1.bCross = false;
        end
        
        if bTrim1 == false
            nR = nR + 1;
            R(nR) = Rcr1;
        end
        
        if bTrim2 == false
            nR = nR + 1;
            R(nR) = Rcr2;
        end
        
        % ���µ�ǰ��ѡ�еľ����е�Ԫ��
        R(i).x2 = R(i).x1 + c;
        R(i).y2 = R(i).y1 + d;
        R(i).bUsed = true;
        R(i).indexS = k;
        
        if bPlot == true
            plot( [R(i).x1, R(i).x2, R(i).x2, R(i).x1, R(i).x1], [R(i).y1, R(i).y1, R(i).y2, R(i).y2, R(i).y1]);
            hold on
        end
        
    end
    
    % ����Ŀ�꺯��
    sumUnused = 0;
    for i=1:1:max(  size(R(1,:)) );
        if R(i).bUsed == false
            sumUnused = sumUnused + (R(i).x2 - R(i).x1) * (R(i).y2 - R(i).y1);
        end
    end
    
    ratio = sumUnused/a/b;
    
    if bPlot == true
        hold off;
    end
    
end

function [i Sk] = SelectRi( R, Sk, err )
% input: R�������漯�ϣ�Sk����Ʒ�ϴ�С���������з����ԣ���err������Ʒ�ϵĳ�������εĳ���֮��Ĳ�ֵС��err��ѡ�ô˾��Σ�
%            ������ѡ�����ܳ����Ʒ���ܳ������С�ľ��Ρ�
% output: i��R(i)��ѡ�вü���Ʒ��Sk����Ʒ�ϴ�С��������з����ԣ���

    nNum = max(  size(R(1,:)) );
    k = 0;
    
    Candi = zeros(1,3);
    diff = 1e5;
    
    for j=1:1:nNum
        
        bRecord = false;
        if R(j).bUsed == false
            
            Raw.length = R(j).x2 - R(j).x1;
            Raw.width = R(j).y2 - R(j).y1;
            
            Product.length = max( Sk(1), Sk(2) );
            Product.width = min( Sk(1), Sk(2) );

            lml = Raw.length - Product.length;
            wmw = Raw.width - Product.width;    
            if ( lml>=0 && wmw>=0 )
                if ( lml<err || wmw<err)
                     i = j;
                     Sk(1) = Product.length;
                     Sk(2) = Product.width;
                     return;
                else
                    tmp = lml + wmw;
                    if ( tmp < diff)
                         Candi(1) = j;
                         Candi(2) = tmp;
                         Candi(3) = Product.length;
                         Candi(4) = Product.width;
                         diff = tmp;
                         bRecord = true;
                    end
                end
            end
            
            wml = Raw.width - Product.length;
            lmw = Raw.length - Product.width;
            if (wml>=0 && lmw>=0)
                if (wml<err || lmw<err)
                    i = j;
                    Sk(1) = Product.width;
                    Sk(2) = Product.length;
                    return;
                else
                    if bRecord == true
                        continue;
                    end
                    tmp = wml + lmw;
                    if ( tmp < diff)
                         Candi(1) = j;
                         Candi(2) = tmp;
                         Candi(3) = Product.width;
                         Candi(4) = Product.length;
                         diff = tmp;
                         bRecord = true;
                    end
                end
            end
        end
    end
    
    % ����������õĽ���������Ĳ�ֵ��error�ڣ�����ô��ѡԭ�����Ʒ���ܳ�����С���ǿ�ԭ��
    if Candi(1) > 0
        i = Candi(1);
        Sk(1) = Candi(1, 3);
        Sk(2) = Candi(1, 4);
        return;
    end
    
    %�Ҳ�����ǰ��Ʒ����Ӧ��ԭ�ϼ�
    i = 0;
    
end

%�����������ν��沿��
function [x1, y1, x2, y2] = Com( R1, R2 )
     x1 = max( R1.x1, R2.x1 );
     y1 = max( R1.y1, R2.y1 );
     x2 = min( R1.x2, R2.x2 );
     y2 = min( R1.y2, R1.y2 );
end