from xetusoss/archiva
USER archiva
COPY ./archiva-data/ /archiva-data2/
USER root
RUN chown -R archiva:archiva /archiva-data2
ENV ARCHIVA_BASE /archiva-data2
USER archiva